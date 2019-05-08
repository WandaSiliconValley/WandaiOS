//
//  ForgotPasswordViewController.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/22/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import FirebaseAuth
import Foundation
import MessageUI
import UIKit

class ForgotPasswordViewController: UIViewController, MFMailComposeViewControllerDelegate, WandaAlertViewDelegate, UITextFieldDelegate  {
    @IBOutlet private weak var emailInfoLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var resetPasswordButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!

    var email: String?

    static let storyboardIdentifier = String(describing: ForgotPasswordViewController.self)
    private var actionState: ActionState = .resetPassword
    private var dataManager = WandaDataManager.shared

    enum ActionState {
        case resetPassword
        case success
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
    }

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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.view.layoutIfNeeded()
        emailTextField.underlined()

        if let email = email {
            emailTextField.text = email
        }
    }

    // MARK: Private

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: WandaImages.backArrow, style: .plain, target: self, action: #selector(backButtonPressed))

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.wandaFontBold(size: 20)]
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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

    @objc
    private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: IBActions

    @IBAction func didEditEmail() {
        emailInfoLabel.configureValidEmail(emailTextField)
    }

    @IBAction func didTapResetPassword() {
        guard let email = emailTextField.text, email.isEmailValid(emailTextField: emailTextField, emailInfoLabel: emailInfoLabel) else {
            return
        }

        spinner.toggleSpinner(for: resetPasswordButton, title: LoginSignUpStrings.resetPassword)
        logAnalytic(tag: WandaAnalytics.resetPasswordTapped)

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                self.spinner.toggleSpinner(for: self.resetPasswordButton, title: LoginSignUpStrings.resetPassword)
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    let errorString = FirebaseError(errorCode: errorCode.rawValue)
                    self.logAnalytic(tag: "\(WandaAnalytics.resetPassowordError)_\(errorString.rawValue)")
                    switch errorCode {
                        case .networkError:
                            self.actionState = .resetPassword
                            self.presentErrorAlert(for: .networkError)
                        case .userNotFound:
                            // If the user is not found we still want a 'success' modal to pop up for security reasons.
                            self.actionState = .success
                            self.presentErrorAlert(for: .forgotPasswordSuccess)
                        default:
                            self.actionState = .resetPassword
                            self.presentErrorAlert(for: .systemError)
                        }
                }
                return
            }
 
            self.actionState = .success
            self.logAnalytic(tag: WandaAnalytics.resetPasswordSuccess)
            self.presentErrorAlert(for: .forgotPasswordSuccess)
            self.spinner.toggleSpinner(for: self.resetPasswordButton, title: LoginSignUpStrings.resetPassword)
        }
    }

    @IBAction func didTapContactUs() {
        guard let contactUsViewController = ViewControllerFactory.makeContactUsViewController(for: .signUp) else {
            self.presentErrorAlert(for: .contactUsError)
            return
        }
        
        logAnalytic(tag: WandaAnalytics.resetPasswordContactUsTapped)
        contactUsViewController.mailComposeDelegate = self
        self.present(contactUsViewController, animated: true) {
            // to do check if working - this is depracated
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }

    // MARK: WandaAlertViewDelegate
    func didTapActionButton() {
        switch actionState {
        case .resetPassword:
            didTapResetPassword()
        case .success:
            return
        }
    }
}
