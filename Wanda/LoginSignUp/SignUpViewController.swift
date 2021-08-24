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
    @IBOutlet private weak var showHidePasswordButton: UIButton!
    @IBOutlet private weak var showHideConfirmPasswordButton: UIButton!
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
            navigationBar.isTranslucent = true
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80.0)
        }
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        guard let userInfo = notification.userInfo else {
            return
        }
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 60
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
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: WandaImages.backArrow, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(hexString: "#663498")

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.wandaFontBold(size: 20)]
        }
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
        self.present(contactUsViewController, animated: true, completion: nil)
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
        let icon = showPasswordClicked ? WandaImages.eyeIcon : WandaImages.eyeOffIcon
        showHidePasswordButton.setImage(icon, for: .normal)
        passwordTextField.isSecureTextEntry = showPasswordClicked
        showPasswordClicked = !showPasswordClicked
    }
    
    @IBAction private func didTapShowHideConfirmPasswordButton() {
        let icon = showConfirmPasswordClicked ? WandaImages.eyeIcon : WandaImages.eyeOffIcon
        showHidePasswordButton.setImage(icon, for: .normal)
        showHideConfirmPasswordButton.imageView?.image  = showConfirmPasswordClicked ? WandaImages.eyeOffIcon : WandaImages.eyeIcon
        confirmPasswordTextField.isSecureTextEntry = showConfirmPasswordClicked
        showConfirmPasswordClicked = !showConfirmPasswordClicked
    }
    
    @IBAction private func didTapSignUp() {
        guard verifySignUp(), let email = emailTextField.text else {
            return
        }
        
        spinner.toggleSpinner(for: signUpButton, title: GeneralStrings.submitAction)
        logAnalytic(tag: WandaAnalytics.signUpButtonTapped)
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let motherId = authResult?.user.uid else {
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    self.spinner.toggleSpinner(for: self.signUpButton, title: GeneralStrings.submitAction)
                    let errorString = FirebaseError(errorCode: errorCode.rawValue)
                    self.logAnalytic(tag: "\(WandaAnalytics.signUpError)_\(errorString.rawValue)")
                    switch errorCode {
                        case .networkError:
                            self.actionState = .retryCreateFirebaseUser
                            self.presentErrorAlert(for: .networkError)
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
    
    private func getCohort() {
        guard let cohortId = dataManager.wandaMother?.cohortId else {
            return
        }
        dataManager.getCohort(cohortId: cohortId) { success, error in
            guard success else {
                if let error = error {
                    // Set action state to retry get mother so the user has the option to retry the API call.
//                    TO DO - add in retry
//                    self.actionState = .retryGetMother
                    switch error {
                        case .networkError:
                            self.presentErrorAlert(for: .networkError)
                        default:
                            self.presentErrorAlert(for: .systemError)
                    }
                }
                
                return
            }
            return
        }
        return
    }
    
    private func createWandaMother() {
        guard verifySignUp(), let email = emailTextField.text, let motherId = motherId else {
            return
        }
        
        self.dataManager.createWandaAccount(firebaseId: motherId, email: email) { success, error in
            guard success, let signUpSuccessViewController = ViewControllerFactory.makeWandaSuccessController() else {
                Auth.auth().currentUser?.delete { error in
                    // to do should we fail this siletnly and just log an analytics tag?
                    print("Couldn't delete user")
                }
                
                if let error = error {
                    self.actionState = .retryCreateWandaMother
                    self.spinner.toggleSpinner(for: self.signUpButton, title: GeneralStrings.submitAction)
                    switch error {
                        case .networkError:
                            self.presentErrorAlert(for: .networkError)
                        default:
                            self.presentErrorAlert(for: .systemError)
                    }
                }
                
                return
            }
            
            self.getCohort()
            signUpSuccessViewController.successType = .signUp
            self.spinner.toggleSpinner(for: self.signUpButton, title: GeneralStrings.submitAction)
            self.navigationController?.pushViewController(signUpSuccessViewController, animated: true)
        }
    }
    
    @IBAction private func didTapContactUs() {
        // to do we will want contact support once we get the retry limit in place - retry 2 times then contact support
        logAnalytic(tag: WandaAnalytics.signUpContactUsTapped)
        contactSupport()
    }
    
    // MARK: WandaAlertViewDelegate
    
    func didTapActionButton() {
        switch actionState {
            case .retryCreateFirebaseUser:
                didTapSignUp()
            case .retryCreateWandaMother:
                self.spinner.toggleSpinner(for: self.signUpButton, title: GeneralStrings.submitAction)
                createWandaMother()
        }
    }

    // MARK: MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.

        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
