//
//  WandaSuccessViewController.swift
//  Wanda
//
//  Created by Bell, Courtney on 5/16/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//
import UIKit
import MessageUI
enum SuccessType {
    case update
    case reservation
    case signUp
}
class WandaSuccessViewController: UIViewController, WandaAlertViewDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet private weak var successImage: UIImageView!
    @IBOutlet private weak var successTitle: UILabel!
    @IBOutlet private weak var successMessage: UILabel!
    @IBOutlet private weak var signUpNextButton: UIButton!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    var successType: SuccessType = .signUp
    
    private var dataManager = WandaDataManager.shared
    static let storyboardIdentifier = String(describing: WandaSuccessViewController.self)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        if let navigationBar = self.navigationController?.navigationBar {
        //    navigationBar.barTintColor = WandaColors.darkPurple
            navigationBar.isTranslucent = true
        }
        configureSuccessView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigationBar = self.navigationController?.navigationBar {
           // navigationBar.isTranslucent = false
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80.0)
        }
    }
    
    // MARK: IBActions
    @IBAction func didTapSignUpNextButton() {
        spinner.toggleSpinner(for: signUpNextButton, title: GeneralStrings.nextAction)
        dataManager.getWandaClasses() { success, error in
            guard success, let classesViewController = ViewControllerFactory.makeTabbedViewController() else {
                if let error = error {
                    self.spinner.toggleSpinner(for: self.signUpNextButton, title: GeneralStrings.nextAction)
                    switch error {
                        case .networkError:
                            self.presentErrorAlert(for: .networkError)
                        default:
                            self.presentErrorAlert(for: .systemError)
                    }
                }
                return
            }
            
            self.dataManager.needsReload = true
            self.spinner.toggleSpinner(for: self.signUpNextButton, title: GeneralStrings.nextAction)
            self.navigationController?.pushViewController(classesViewController, animated: true)
        }
    }
    
    // MARK: Private
    @objc
    private func closeView() {
        dataManager.needsReload = true
        
        let didPopBack = popBack(toControllerType: TabbedViewController.self)
        
        if didPopBack == false {
            guard let classesViewController = ViewControllerFactory.makeTabbedViewController() else {
                assertionFailure("Could not load the LoginViewController.")
                return
            }

            self.navigationController?.pushViewController(classesViewController, animated: true)
        }
    }
    
    private func configureSuccessView() {
        switch successType {
            case .update:
                self.navigationController?.isModalInPopover = true
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: WandaImages.closeIcon, style: .plain, target: self, action: #selector(closeView))
                navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                view.backgroundColor = WandaColors.lightPurple
                successImage.image = WandaImages.successCalendar
                successTitle.text = "Your RSVP has been updated!"
                successMessage.text = SuccessStrings.reservationSuccessMessage
                signUpNextButton.isHidden = true
            case .reservation:
                self.navigationController?.isModalInPopover = true
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: WandaImages.closeIcon, style: .plain, target: self, action: #selector(closeView))
                navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                view.backgroundColor = WandaColors.lightPurple
                successImage.image = WandaImages.successCalendar
                successTitle.text = SuccessStrings.thanksForSigningUp
                successMessage.text = SuccessStrings.reservationSuccessMessage
                signUpNextButton.isHidden = true
            case .signUp:
                successImage.image = WandaImages.successEmail
                successTitle.text = SuccessStrings.accountCreated
                successMessage.text = SuccessStrings.signUpSuccessMessage
                signUpNextButton.isHidden = false
        }
    }
    // MARK: WandaAlertViewDelegate
    func didTapActionButton() {
        // This retries getting the wanda classes.
        didTapSignUpNextButton()
    }
}
