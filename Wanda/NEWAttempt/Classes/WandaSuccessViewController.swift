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
    case reservation
    case signUp
}

class WandaSuccessViewController: UIViewController, WandaAlertViewDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet private weak var successImage: UIImageView!
    @IBOutlet private weak var successTitle: UILabel!
    @IBOutlet private weak var successMessage: UILabel!
    @IBOutlet private weak var signUpNextButton: UIButton!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!

    var dataManager = WandaDataManager.shared
    var successType: SuccessType = .signUp

    static let storyboardIdentifier = String(describing: WandaSuccessViewController.self)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true

        configureSuccessView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // to do why cant i do this in viewwillappear? still see the flash of the nav bar
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.isTranslucent = false
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80.0)
        }
    }

    func configureSuccessView() {
        switch successType {
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
            // to do fine to set this in storyboard for now but not
            // error proof, same hex value but setting the color here looks different
            // than in storyboard
           //     view.backgroundColor = WandaColors.darkPurple
                successImage.image = WandaImages.successEmail
                successTitle.text = SuccessStrings.accountCreated
                successMessage.text = SuccessStrings.signUpSuccessMessage
                signUpNextButton.isHidden = false
        }
    }

    @IBAction func didTapSignUpNextButton() {
        spinner.toggleSpinner(for: signUpNextButton, title: GeneralStrings.nextAction)
        dataManager.getWandaClasses() { success in
            guard success, let classesViewController = ViewControllerFactory.makeClassesViewController() else {
                if let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.systemError, delegate: self) {
                    self.spinner.toggleSpinner(for: self.signUpNextButton, title: GeneralStrings.nextAction)
                    self.present(wandaAlertViewController, animated: true, completion: nil)
                }
                return
            }

            classesViewController.dataManager = self.dataManager
            self.spinner.toggleSpinner(for: self.signUpNextButton, title: GeneralStrings.nextAction)
            self.navigationController?.pushViewController(classesViewController, animated: true)
        }
    }

    @objc
    private func closeView() {
        dataManager.needsReload = true
        self.popBack(toControllerType: ClassesViewController.self)
    }

    // super cool! understand this better
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }

    // MARK: WandaAlertViewDelegate

    func didTapActionButton() {
        // to do still want to make this reusable
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }

        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self

        composeVC.setToRecipients(["address@example.com"])
        composeVC.setSubject("Hello!")
        composeVC.setMessageBody("Hello this is my message body!", isHTML: false)

        self.present(composeVC, animated: true, completion: nil)
    }
}

