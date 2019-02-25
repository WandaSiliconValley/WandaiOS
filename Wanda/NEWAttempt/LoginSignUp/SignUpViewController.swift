//
//  SignUpViewController.swift
//  Wanda
//
//  Created by Bell, Courtney on 1/4/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import BrightFutures
import Firebase
import MessageUI
import UIKit

class SignUpViewController: UIViewController, MFMailComposeViewControllerDelegate, WandaAlertViewDelegate {
    @IBOutlet private weak var emailInfoLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordInfoLabel: UILabel!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordInfoLabel: UILabel!
    @IBOutlet private weak var signUpButton: UIButton!

    var dataManager: WandaDataManager?

    private var showPasswordClicked = false
    private var showConfirmPasswordClicked = false

    static let storyboardIdentifier = String(describing: SignUpViewController.self)

    override func viewDidLoad() {
        configureNavigationBar()
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        passwordTextField.underlined()
        emailTextField.underlined()
        confirmPasswordTextField.underlined()
    }

    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: WandaImages.backArrow, style: .plain, target: self, action: #selector(backButtonPressed))

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.wandaFontBold(size: 20)]
        }
    }

    @objc
    private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func verifyConfirmationPassword() -> Bool {
        guard let userPassword = confirmPasswordTextField.text, !userPassword.isEmpty, confirmPasswordTextField.text == passwordTextField.text else {
            confirmPasswordInfoLabel.text = LoginSignUpStrings.passwordsDoNotMatch
            confirmPasswordInfoLabel.textColor = WandaColors.errorRed
            confirmPasswordTextField.shake()
            return false
        }

        return true
    }

    @IBAction func didEditPassword() {
        guard confirmPasswordTextField.text == passwordTextField.text else {
            confirmPasswordInfoLabel.text = ""
            return
        }

        confirmPasswordInfoLabel.text = GeneralStrings.confirmed
        confirmPasswordInfoLabel.textColor = WandaColors.limeGreen
    }

    @IBAction func didTapShowHidePasswordButton() {
        passwordTextField.isSecureTextEntry = showPasswordClicked
        showPasswordClicked = !showPasswordClicked
    }

    @IBAction func didTapShowHideConfirmPasswordButton() {
        confirmPasswordTextField.isSecureTextEntry = showConfirmPasswordClicked
        showConfirmPasswordClicked = !showConfirmPasswordClicked
    }

    @IBAction func didTapSignUp() {
        guard let dataManager = dataManager, let userEmail = emailTextField.text, userEmail.verifyEmail(emailTextField: emailTextField, emailInfoLabel: emailInfoLabel), let userPassword = passwordTextField.text, userPassword.verifyPassword(passwordTextField: passwordTextField, passwordInfoLabel: passwordInfoLabel), verifyConfirmationPassword() else {
            return
        }

        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (authResult, error) in
            guard let motherId = authResult?.user.uid else {
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                        case .wrongPassword, .userNotFound:
                            self.confirmPasswordInfoLabel.text = ErrorStrings.invalidCredentials
                            self.confirmPasswordInfoLabel.isHidden = false
                        default:
                            if let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.systemError, delegate: self) {
                                self.present(wandaAlertViewController, animated: true, completion: nil)
                            }
                    }
                }

                return
            }

            self.confirmPasswordInfoLabel.isHidden = true
            dataManager.createWandaAccount(firebaseId: motherId, email: userEmail) { success in
                guard success, let signUpSuccessViewController = ViewControllerFactory.makeWandaSuccessController() else {
                    // to do hate this in all instances can we either make this more reusable or move into datamanager?
                    if let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.systemError, delegate: self) {
                        self.present(wandaAlertViewController, animated: true, completion: nil)
                    }

                    return
                }
                signUpSuccessViewController.successType = .signUp
                self.navigationController?.pushViewController(signUpSuccessViewController, animated: true)
            }
        }
    }

    // MARK: WandaAlertViewDelegate

    func didTapActionButton() {
        contactSupport()
    }

    @IBAction func didTapContactUs() {
        contactSupport()
    }

    private func contactSupport() {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }

        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self

        // Configure the fields of the interface.
        composeVC.setToRecipients(["address@example.com"])
        composeVC.setSubject("Hello!")
        composeVC.setMessageBody("Hello this is my message body!", isHTML: false)

        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
}
