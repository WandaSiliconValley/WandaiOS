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

class SignUpViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, WandaAlertViewDelegate {
    @IBOutlet private weak var emailInfoLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordInfoLabel: UILabel!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordInfoLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!

    private var dataManager = WandaDataManager.shared
    private var passwordsMatch: Bool {
        return passwordTextField.text == confirmPasswordTextField.text
    }
    private var showPasswordClicked = false
    private var showConfirmPasswordClicked = false

    static let storyboardIdentifier = String(describing: SignUpViewController.self)


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
        configureNavigationBar()
//        passwordTextField.isSecureTextEntry = true
//        confirmPasswordTextField.isSecureTextEntry = true
        passwordTextField.underlined()
        emailTextField.underlined()
        confirmPasswordTextField.underlined()
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
        guard let userInfo = notification.userInfo else {return}
//guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
//        if self.view.frame.origin.y == 0{                       self.view.frame.origin.y -= keyboardFrame.height
//        }
//
//
//        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
      //  keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
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

    private func verifySignUp() -> Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return false
        }

        if !passwordsMatch {
            passwordInfoLabel.configureError(LoginSignUpStrings.passwordsDoNotMatch, invalidTextField: passwordTextField)
        }

        let emailValid = email.isEmailValid(emailTextField: emailTextField, emailInfoLabel: emailInfoLabel)
        let passwordValid = password.isPasswordValid(passwordTextField: passwordTextField, passwordInfoLabel: passwordInfoLabel)
        let confirmationPasswordValid = isConfirmationPasswordValid()

        return emailValid && passwordValid && confirmationPasswordValid && passwordsMatch
    }

    private func isConfirmationPasswordValid() -> Bool {
        guard let password = passwordTextField.text, let confirmationPassword = confirmPasswordTextField.text else {
            return false
        }

        if password.isEmpty && !confirmationPassword.isEmpty {
            passwordInfoLabel.configureError(LoginSignUpStrings.passwordsDoNotMatch, invalidTextField: passwordTextField)

            return false
        }

        return true
    }

    @IBAction func didEditEmail() {
        emailInfoLabel.configureValidEmail(emailTextField)
    }

    @IBAction func didEditPassword() {
        passwordInfoLabel.isHidden = true
        passwordTextField.underlined(color: UIColor.white.cgColor)
        confirmPasswordInfoLabel.isHidden = true
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
        guard verifySignUp(), let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        spinner.toggleSpinner(for: signUpButton, title: GeneralStrings.submitAction)

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let motherId = authResult?.user.uid else {
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    self.spinner.toggleSpinner(for: self.signUpButton, title: GeneralStrings.submitAction)

                    switch errorCode {
                        case .invalidEmail, .missingEmail:
                            _ = email.isEmailValid(emailTextField: self.emailTextField, emailInfoLabel: self.emailInfoLabel)
                        case .emailAlreadyInUse:
                            self.emailInfoLabel.configureError(LoginSignUpStrings.emailInUse, invalidTextField: self.emailTextField)
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
            self.dataManager.createWandaAccount(firebaseId: motherId, email: email) { success in
                guard success, let signUpSuccessViewController = ViewControllerFactory.makeWandaSuccessController() else {
                    self.spinner.toggleSpinner(for: self.signUpButton, title: GeneralStrings.submitAction)
                    // to do hate this in all instances can we either make this more reusable or move into datamanager?
                    if let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.systemError, delegate: self) {
                        self.present(wandaAlertViewController, animated: true, completion: nil)
                    }

                    return
                }
                signUpSuccessViewController.successType = .signUp
                self.spinner.toggleSpinner(for: self.signUpButton, title: GeneralStrings.submitAction)
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
