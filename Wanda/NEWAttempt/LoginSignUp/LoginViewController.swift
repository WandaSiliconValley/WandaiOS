//
//  LoginViewController.swift
//  Wanda
//
//  Created by Bell, Courtney on 11/19/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import EventKit
import EventKitUI
import Firebase
import FirebaseAuth
import MessageUI
import UIKit

class LoginViewController: UIViewController, MFMailComposeViewControllerDelegate, WandaAlertViewDelegate  {
    @IBOutlet private weak var emailInfoLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var passwordInfoLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!

    private var dataManager = WandaDataManager.shared
    private var isValidEmail = false
    private var isValidPassword = false
    private var showHideIconClicked = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.isTranslucent = false
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
                          navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80.0)
        }
    }

    override func viewDidLoad() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.underlined()
        emailTextField.underlined()
    }

    @IBAction func didTapShowHideButton() {
        passwordTextField.isSecureTextEntry = showHideIconClicked
        showHideIconClicked = !showHideIconClicked
    }

    @IBAction func didTapForgotPassword() {
        guard let forgotPasswordViewController = ViewControllerFactory.makeForgotPasswordController() else {
            assertionFailure("Could not load the ForgotPasswordViewController.")
            return
        }

        self.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }

    @IBAction func didTapSignUp() {
        guard let signUpViewController = ViewControllerFactory.makeSignUpViewController() else {
            assertionFailure("Could not load the SignUpViewController.")
            return
        }

        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }

    @IBAction func didTapLogin() {
        guard let userEmail = emailTextField.text, userEmail.verifyEmail(emailTextField: emailTextField, emailInfoLabel: emailInfoLabel), let userPassword = passwordTextField.text, userPassword.verifyPassword(passwordTextField: passwordTextField, passwordInfoLabel: passwordInfoLabel) else {
            return
        }

        // Sign in existing user.
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            guard let firebaseId = authResult?.user.uid else {
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                        case .wrongPassword, .userNotFound:
                            self.passwordInfoLabel.text = ErrorStrings.invalidCredentials
                            self.passwordInfoLabel.isHidden = false
                        default:
                            if let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.systemError, delegate: self) {
                                self.present(wandaAlertViewController, animated: true, completion: nil)
                            }
                        }
                }

                return
            }

            self.passwordInfoLabel.isHidden = true
            self.dataManager.getWandaMother(firebaseId: firebaseId) { success in
                guard success else {
                    self.presentSystemErrorAlert()
                    return
                }

                self.dataManager.getWandaClasses() { success in
                    guard success else {
                        self.presentSystemErrorAlert()
                        return
                    }
                    DispatchQueue.main.async {
                        guard let classesViewController = ViewControllerFactory.makeClassesViewController() else {
                            return
                        }

                        self.navigationController?.pushViewController(classesViewController, animated: true)
                    }
                }
            }
        }
    }

    // MARK: Private

    private func presentSystemErrorAlert() {
        guard let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.systemError, delegate: self) else {
            assertionFailure("Could not instantiate WandaAlertViewController.")
            return
        }

        self.present(wandaAlertViewController, animated: true, completion: nil)
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

extension LoginViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
    }
}
