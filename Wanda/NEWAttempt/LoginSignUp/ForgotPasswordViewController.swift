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
    func didTapActionButton() {
        print("AACTION")
    }

    @IBOutlet private weak var emailInfoLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var resetPasswordButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!

    var dataManager = WandaDataManager.shared
    var userEmail: String?

    static let storyboardIdentifier = String(describing: ForgotPasswordViewController.self)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
    }

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
        emailTextField.underlined()

        if let userEmail = userEmail {
            emailTextField.text = userEmail
        }
    }

    // MARK: Private

    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: WandaImages.backArrow, style: .plain, target: self, action: #selector(backButtonPressed))

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.wandaFontBold(size: 20)]
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

    @IBAction func didTapResetPassword() {
        guard let userEmail = emailTextField.text, userEmail.verifyEmail(emailTextField: emailTextField, emailInfoLabel: emailInfoLabel) else {
            return
        }

        Auth.auth().sendPasswordReset(withEmail: userEmail) { error in
            guard error == nil else {
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .wrongPassword, .userNotFound:
                        self.emailTextField.shake()
                        self.emailInfoLabel.font = UIFont.wandaFontItalic(size: 10)
                        self.emailInfoLabel.textColor = .red
                        self.emailInfoLabel.text = ErrorStrings.invalidCredentials
                        self.emailInfoLabel.isHidden = false
                    default:
                        if let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.forgotPasswordError, delegate: self) {
                            self.present(wandaAlertViewController, animated: true, completion: nil)
                        }
                    }
                }
                return
            }

            if let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.forgotPasswordSuccess, delegate: self) {
                self.present(wandaAlertViewController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func didTapContactUs() {
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
