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

class LoginViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, WandaAlertViewDelegate, EKEventEditViewDelegate {
    @IBOutlet private weak var emailInfoLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var passwordInfoLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!

    private var actionState: ActionState = .contactUs
    private var dataManager = WandaDataManager.shared
    private var firebaseId: String?
    private var isValidEmail = false
    private var isValidPassword = false
    private var showHideIconClicked = false

    private enum ActionState {
        case contactUs
        case retryGetClasses
        case retryGetMother
        case retryLogin
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.barTintColor = WandaColors.darkPurple
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // to do look at ease scene styles
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.isTranslucent = false
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80.0)
        }
        passwordTextField.underlined()
        emailTextField.underlined()
    }

    override func viewDidLoad() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIApplication.keyboardWillHideNotification, object: nil)
        passwordTextField.isSecureTextEntry = true
    }

    // MARK: Private

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
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
    
    private func loginWithFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let firebaseId = authResult?.user.uid else {
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    self.spinner.toggleSpinner(for: self.loginButton, title: LoginSignUpStrings.login)
                    let errorString = FirebaseError(errorCode: errorCode.rawValue)
                    self.logAnalytic(tag: "\(WandaAnalytics.loginError)_\(errorString.rawValue)")
                    switch errorCode {
                        case .networkError:
                            // Set action state to retry login so the user has the option to retry the API call.
                            self.actionState = .retryLogin
                            self.presentErrorAlert(for: .networkError)
                        case .invalidEmail, .missingEmail:
                            _ = email.isEmailValid(emailTextField: self.emailTextField, emailInfoLabel: self.emailInfoLabel)
                        case .wrongPassword, .userNotFound:
                            self.emailInfoLabel.configureError(ErrorStrings.invalidCredentials, invalidTextField: self.emailTextField)
                        default:
                            // Set action state to retry login so the user has the option to retry the API call.
                            self.actionState = .retryLogin
                            self.presentErrorAlert(for: .systemError)
                    }
                }

                return
            }

            // Ensure action state is set back to contact us if the call was successful.
            self.actionState = .contactUs
            // We store the firebase id for the case that the get mother api call needs to be retried.
            self.firebaseId = firebaseId
            self.getWandaMother()
        }
    }

    private func getWandaMother() {
        guard let firebaseId = firebaseId else {
            return
        }

        dataManager.getWandaMother(firebaseId: firebaseId) { success in
            guard success else {
                self.spinner.toggleSpinner(for: self.loginButton, title: LoginSignUpStrings.login)
                self.presentErrorAlert(for: .networkError)
                // Set action state to retry get mother so the user has the option to retry the API call.
                self.actionState = .retryGetMother
                return
            }
        }

        // Ensure action state is set back to contact us if the call was successful.
        actionState = .contactUs
        getClasses()
    }

    private func getClasses() {
        self.dataManager.getWandaClasses() { success in
            guard success else {
                // Set action state to retry get classes so the user has the option to retry the API call.
                self.actionState = .retryGetClasses
                self.spinner.toggleSpinner(for: self.loginButton, title: LoginSignUpStrings.login)
                self.presentErrorAlert(for: .cantGetClasses)
                return
            }

            // Ensure action state is set back to contact us if the call was successful.
            self.actionState = .contactUs
            DispatchQueue.main.async {
                guard let classesViewController = ViewControllerFactory.makeClassesViewController() else {
                    assertionFailure("Could not instantiate ClassesViewController.")
                    return
                }

                self.spinner.toggleSpinner(for: self.loginButton, title: LoginSignUpStrings.login)
                self.dataManager.needsReload = true
                self.navigationController?.pushViewController(classesViewController, animated: true)
            }
        }
    }

    // to do how is this being used here right now?
    private func contactUs() {
        guard let contactUsViewController = ViewControllerFactory.makeContactUsViewController(for: .login) else {
            self.presentErrorAlert(for: .contactUsError)
            return
        }

        contactUsViewController.mailComposeDelegate = self
        self.present(contactUsViewController, animated: true, completion: nil)
    }

    // MARK: IBActions

    @IBAction private func didEditEmail() {
        emailInfoLabel.configureValidEmail(emailTextField)
    }

    @IBAction private func didEditPassword() {
        passwordInfoLabel.isHidden = true
        passwordTextField.underlined()
    }

    @IBAction private func didTapShowHideButton() {
        passwordTextField.isSecureTextEntry = showHideIconClicked
        showHideIconClicked = !showHideIconClicked
    }

    @IBAction private func didTapForgotPassword() {
        guard let forgotPasswordViewController = ViewControllerFactory.makeForgotPasswordController() else {
            assertionFailure("Could not load the ForgotPasswordViewController.")
            return
        }

        if let email = emailTextField.text {
            forgotPasswordViewController.email = email
        }

        logAnalytic(tag: WandaAnalytics.loginForgotPasswordTapped)
        self.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }

    @IBAction func didTapSignUp() {
        guard let signUpViewController = ViewControllerFactory.makeSignUpViewController() else {
            assertionFailure("Could not load the SignUpViewController.")
            return
        }

        logAnalytic(tag: WandaAnalytics.loginSignUpButtonTapped)
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }

    private func verifySignUp() -> Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return false
        }

        let emailValid = email.isEmailValid(emailTextField: emailTextField, emailInfoLabel: emailInfoLabel)
        let passwordValid = password.isPasswordValid(passwordTextField: passwordTextField, passwordInfoLabel: passwordInfoLabel, checkLength: false)

        return emailValid && passwordValid
    }

    @IBAction private func didTapLogin() {
        guard verifySignUp(), let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        
        logAnalytic(tag: WandaAnalytics.loginButtonTapped)
        spinner.toggleSpinner(for: loginButton, title: LoginSignUpStrings.login)
        loginWithFirebase(email: email, password: password)
    }

    // MARK: WandaAlertViewDelegate

    func didTapActionButton() {
        switch actionState {
            case .contactUs:
                contactUs()
            case .retryGetClasses:
                getClasses()
            case .retryGetMother:
                getWandaMother()
            case .retryLogin:
                didTapLogin()
        }
    }

    // MARK: EKEventEditViewDelegate

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
    }
}
