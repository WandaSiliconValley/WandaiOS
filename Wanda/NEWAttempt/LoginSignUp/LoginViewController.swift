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

class LoginViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, WandaAlertViewDelegate  {
    @IBOutlet private weak var emailInfoLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var passwordInfoLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!

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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.underlined()
        emailTextField.underlined()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }

    @objc
    func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc
    func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

    @IBAction func didEditEmail() {
        emailInfoLabel.configureValidEmail(emailTextField)
    }

    @IBAction func didEditPassword() {
        passwordInfoLabel.isHidden = true
        passwordTextField.underlined(color: UIColor.white.cgColor)
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

        if let email = emailTextField.text {
            forgotPasswordViewController.email = email
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

    private func verifySignUp() -> Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return false
        }

        let emailValid = email.isEmailValid(emailTextField: emailTextField, emailInfoLabel: emailInfoLabel)
        let passwordValid = password.isPasswordValid(passwordTextField: passwordTextField, passwordInfoLabel: passwordInfoLabel)

        return emailValid && passwordValid
    }

    @IBAction func didTapLogin() {
        guard verifySignUp(), let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        spinner.toggleSpinner(for: loginButton, title: LoginSignUpStrings.login)

        // Sign in existing user.
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let firebaseId = authResult?.user.uid else {
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    self.spinner.toggleSpinner(for: self.loginButton, title: LoginSignUpStrings.login)
                    switch errorCode {
                        case .invalidEmail, .missingEmail:
                            _ = email.isEmailValid(emailTextField: self.emailTextField, emailInfoLabel: self.emailInfoLabel)
                        case .wrongPassword, .userNotFound:
                            self.emailInfoLabel.configureError(ErrorStrings.invalidCredentials, invalidTextField: self.emailTextField)
                        default:
                            if let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.systemError, delegate: self) {
                                self.present(wandaAlertViewController, animated: true, completion: nil)
                            }
                        }
                }

                return
            }

            self.dataManager.getWandaMother(firebaseId: firebaseId) { success in
                guard success else {
                    self.spinner.toggleSpinner(for: self.loginButton, title: LoginSignUpStrings.login)
                    self.presentSystemErrorAlert()
                    return
                }

                self.dataManager.getWandaClasses() { success in
                    guard success else {
                        self.spinner.toggleSpinner(for: self.loginButton, title: LoginSignUpStrings.login)
                        self.presentSystemErrorAlert()
                        return
                    }
                    DispatchQueue.main.async {
                        guard let classesViewController = ViewControllerFactory.makeClassesViewController() else {
                            assertionFailure("Could not instantiate ClassesViewController.")
                            return
                        }

                        self.spinner.toggleSpinner(for: self.loginButton, title: LoginSignUpStrings.login)
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
