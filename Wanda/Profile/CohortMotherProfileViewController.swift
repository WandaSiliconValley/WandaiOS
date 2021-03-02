//
//  CohortMotherProfileViewController.swift
//  Wanda
//
//  Created by Courtney Bell on 2/23/21.
//  Copyright © 2021 Bell, Courtney. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit
import MessageUI

class CohortMotherProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var cohortLabel: UILabel!
    @IBOutlet weak var languagesTitle: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var phoneNumberTitle: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bioTitle: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    static let storyboardIdentifier = String(describing: CohortMotherProfileViewController.self)
//    private var menuView: WandaClassMenu?
    private var dataManager = WandaDataManager.shared
    var cohortMother: WandaCohortMother?
    var cohortId: Int = 0
    private var menuView: WandaMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let cohortMother = cohortMother else {
            // to do - throw error - couldnt retriee profile
            return
        }

        configureNavigationBar()
        let motherName = cohortMother.name
        showInitialView(name: motherName, initialImage: profileImage)
        let downloadURL = URL(string: "https://wanda-photos-bucket.s3-us-west-2.amazonaws.com/\(cohortMother.motherId)")!
        profileImage.af.setImage(withURL: downloadURL)
        configureMotherInfo()
        configureMenu()
    }
    
    func showInitialView(name: String, initialImage: UIImageView) {
        let initialLabel = UILabel()
        initialLabel.frame.size = CGSize(width: 100.0, height: 100.0)
        initialLabel.textColor = UIColor.white
        initialLabel.text = String(name.first?.uppercased() ?? "?")
        initialLabel.font = UIFont.wandaFontRegular(size: 60)
        initialLabel.textAlignment = NSTextAlignment.center
        initialLabel.backgroundColor = WandaColors.mediumPurple

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(initialLabel.bounds.size, false, scale)
        initialLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
        initialImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        initialImage.circularBorder()
    }
    
    func configureMotherInfo() {
        guard let mother = cohortMother else {
            // TO DO handle error
            return
        }
        
//        if let cohortId = mother.cohortId {
        cohortLabel.text = "I'm in Cohort " + String(cohortId)
//        } else {
//            cohortLabel.isHidden = true
//        }
        
        introLabel.text = "Hi, I'm " + mother.name
        
        if mother.bio?.isEmpty == false, let bio = mother.bio {
            bioLabel.text = bio
        }
        
        if mother.shareContactEmail == true, let email = mother.contactEmail {
            emailTitle.isHidden = false
            emailButton.isHidden = false
            emailButton.setTitle(email, for: .normal)
        } else {
            emailTitle.isHidden = true
            emailButton.isHidden = true
        }
    
        if mother.sharePhoneNumber == true, let phoneNumber = mother.phoneNumber {
            phoneNumberTitle.isHidden = false
            phoneNumberButton.isHidden = false
            phoneNumberButton.setTitle(phoneNumber, for: .normal)
        } else {
            phoneNumberTitle.isHidden = true
            phoneNumberButton.isHidden = true
        }
        
        if mother.languages.isEmpty == false {
            languagesTitle.isHidden = false
            languagesLabel.isHidden = false
            languagesLabel.text = configureLanguagesText(mother.languages)
        } else {
            languagesTitle.isHidden = true
            languagesLabel.isHidden = true
        }
    }
    
    
    func configureLanguagesText(_ languages: [String]) -> String {
        var languagesString = ""
        for language in languages {
            if languages.last == language {
                languagesString += language
            } else {
                languagesString += language + ", "
            }
        }
        
        return languagesString
    }
    
    
    private func configureNavigationBar() {
        navigationController?.view.backgroundColor = WandaColors.lightPurple
        if let navigationBar = self.navigationController?.navigationBar {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
            titleLabel.text = "Profile"
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.wandaFontSemiBold(size: 20)
            navigationItem.titleView = titleLabel
            navigationItem.hidesBackButton = true

             navigationItem.leftBarButtonItem = UIBarButtonItem(image: WandaImages.backArrow, style: .plain, target: self, action: #selector(backButtonPressed))
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: WandaImages.overflowIcon, style: .plain, target: self, action: #selector(didTapOverflowMenu))
            navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            navigationBar.barTintColor = WandaColors.lightPurple
            navigationBar.isTranslucent = false
        }
    }

    @objc
    private func didTapOverflowMenu() {
        if let menuView = menuView {
            menuView.toggleMenu()
        }
    }
    
    
    private func configureMenu() {
        menuView = WandaMenu(frame: CGRect(x: 0, y: 0, width: 250, height: 96))
        if let menuView = menuView {
            menuView.frame.origin.y = 0
            menuView.frame.origin.x = self.view.frame.width - menuView.frame.width
            
            self.view.addSubview(menuView)
            self.view.bringSubview(toFront: menuView)
        }
        
        menuView?.logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        menuView?.contactUsButton.addTarget(self, action: #selector(didTapContactWanda), for: .touchUpInside)
    }
    
    @objc
    func didTapLogoutButton() {
        logAnalytic(tag: WandaAnalytics.classLogoutButtonTapped)
        do {
            try Auth.auth().signOut()
        } catch {
            // We are currently failing silently and sending the user back to the LoginViewController.
            print("Couldn't sign user out. Returning back to Login.")
        }
        popBack(toControllerType: LoginViewController.self)
    }
    
    @objc
    private func didTapContactWanda() {
        guard let contactUsViewController = ViewControllerFactory.makeContactUsViewController(for: .wandaClass) else {
            self.presentErrorAlert(for: .contactUsError)
            return
        }
        
        logAnalytic(tag: WandaAnalytics.classDetailMenuContatctWandaTapped)
        contactUsViewController.mailComposeDelegate = self
        contactUsViewController.setSubject("Test Title")
        contactUsViewController.setMessageBody("Test", isHTML: false)
        
        if let menuView = menuView {
            menuView.toggleMenu()
        }
        
        self.present(contactUsViewController, animated: true, completion: nil)
    }
    
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
}
