//
//  SignUpViewController.swift
//  Wanda
//
//  Created by Bell, Courtney on 1/4/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Firebase
import MessageUI
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, WandaAlertViewDelegate {
    @IBOutlet private weak var confirmPasswordInfoLabel: UILabel!
    @IBOutlet private var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var emailInfoLabel: UILabel!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private weak var passwordInfoLabel: UILabel!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!

    private var actionState: ActionState = .retryCreateFirebaseUser
    private var dataManager = WandaDataManager.shared
    private var motherId: String?
    private var password: String {
        guard let password = passwordTextField.text else {
            return ""
        }
        
        return password.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var confirmationPassword: String {
        guard let confirmationPassword = confirmPasswordTextField.text else {
            return ""
        }

        return confirmationPassword.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var passwordsMatch: Bool {
        return password.trimmingCharacters(in: .whitespacesAndNewlines) == confirmationPassword.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var showPasswordClicked = false
    private var showConfirmPasswordClicked = false
    
    private enum ActionState {
        case retryCreateFirebaseUser
        case retryCreateWandaMother
    }

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }


    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        configureNavigationBar()
        // to do !!
//        passwordTextField.isSecureTextEntry = true
//        confirmPasswordTextField.isSecureTextEntry = true
        self.view.layoutIfNeeded()
        passwordTextField.underlined()
        emailTextField.underlined()
        confirmPasswordTextField.underlined()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: Private

    @objc
    private func keyboardWillShow(notification:NSNotification){
        guard let userInfo = notification.userInfo else {return}

        // to do can we make this scroll so the whole screen shows
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: WandaImages.backArrow, style: .plain, target: self, action: #selector(backButtonPressed))

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.wandaFontBold(size: 20)]
        }
    }

    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }

    private func verifySignUp() -> Bool {
        guard let email = emailTextField.text else {
            return false
        }

        if !passwordsMatch {
            passwordInfoLabel.configureError(LoginSignUpStrings.passwordsDoNotMatch, invalidTextField: passwordTextField)
        }

        let emailValid = email.isEmailValid(emailTextField: emailTextField, emailInfoLabel: emailInfoLabel)
        let passwordValid = password.isPasswordValid(passwordTextField: passwordTextField, passwordInfoLabel: passwordInfoLabel, checkLength: true)
        let confirmationPasswordValid = isConfirmationPasswordValid()

        return emailValid && passwordValid && confirmationPasswordValid && passwordsMatch
    }

    private func isConfirmationPasswordValid() -> Bool {
        if password.isEmpty && !confirmationPassword.isEmpty {
            passwordInfoLabel.configureError(LoginSignUpStrings.passwordsDoNotMatch, invalidTextField: passwordTextField)
            return false
        }

        return true
    }

    private func contactSupport() {
        guard let contactUsViewController = ViewControllerFactory.makeContactUsViewController(for: .signUp) else {
            self.presentErrorAlert(for: .contactUsError)
            return
        }

        contactUsViewController.mailComposeDelegate = self
        self.present(contactUsViewController, animated: true) {
            // to do check if working - this is depracated
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }

    // MARK: IBActions

    @IBAction private func didEditEmail() {
        emailInfoLabel.configureValidEmail(emailTextField)
    }

    @IBAction private func didEditPassword() {
        passwordInfoLabel.isHidden = true
        passwordTextField.underlined()
        confirmPasswordInfoLabel.isHidden = true
    }

    @IBAction private func didTapShowHidePasswordButton() {
        passwordTextField.isSecureTextEntry = showPasswordClicked
        showPasswordClicked = !showPasswordClicked
    }

    @IBAction private func didTapShowHideConfirmPasswordButton() {
        confirmPasswordTextField.isSecureTextEntry = showConfirmPasswordClicked
        showConfirmPasswordClicked = !showConfirmPasswordClicked
    }

    @IBAction private func didTapSignUp() {
        guard verifySignUp(), let email = emailTextField.text else {
            return
        }

        spinner.toggleSpinner(for: signUpButton, title: GeneralStrings.submitAction)

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let motherId = authResult?.user.uid else {
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    self.spinner.toggleSpinner(for: self.signUpButton, title: GeneralStrings.submitAction)

                    switch errorCode {
                        case .networkError:
                            self.actionState = .retryCreateFirebaseUser
                            if let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.networkError, delegate: self) {
                                self.present(wandaAlertViewController, animated: true, completion: nil)
                            }
                        case .invalidEmail, .missingEmail:
                            _ = email.isEmailValid(emailTextField: self.emailTextField, emailInfoLabel: self.emailInfoLabel)
                        case .emailAlreadyInUse:
                            self.emailInfoLabel.configureError(LoginSignUpStrings.emailInUse, invalidTextField: self.emailTextField)
                        case .wrongPassword, .userNotFound:
                            self.confirmPasswordInfoLabel.text = ErrorStrings.invalidCredentials
                            self.confirmPasswordInfoLabel.isHidden = false
                        default:
                            self.actionState = .retryCreateFirebaseUser
                            self.presentErrorAlert(for: .systemError)
                    }
                }

                return
            }

            self.motherId = motherId
            self.confirmPasswordInfoLabel.isHidden = true
            self.createWandaMother()
        }
    }
    
    private func createWandaMother() {
        guard verifySignUp(), let email = emailTextField.text, let motherId = motherId else {
            return
        }

        self.dataManager.createWandaAccount(firebaseId: motherId, email: email) { success in
            guard success, let signUpSuccessViewController = ViewControllerFactory.makeWandaSuccessController() else {
                self.actionState = .retryCreateWandaMother
                self.spinner.toggleSpinner(for: self.signUpButton, title: GeneralStrings.submitAction)
                self.presentErrorAlert(for: .systemError)
                return
            }
            signUpSuccessViewController.successType = .signUp
            self.spinner.toggleSpinner(for: self.signUpButton, title: GeneralStrings.submitAction)
            self.navigationController?.pushViewController(signUpSuccessViewController, animated: true)
        }
    }

    @IBAction private func didTapContactUs() {
        // to do we will want contact support once we get the retry limit in place - retry 2 times then contact support
        contactSupport()
    }

    // MARK: WandaAlertViewDelegate

    func didTapActionButton() {
        switch actionState {
            case .retryCreateFirebaseUser:
                didTapSignUp()
            case .retryCreateWandaMother:
                createWandaMother()
        }
    }
}
