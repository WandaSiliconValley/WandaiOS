//
//  String+Wanda.swift
//  Wanda
//
//  Created by Bell, Courtney on 1/5/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation
import UIKit

internal extension String {
    func verifyPassword(passwordTextField: UITextField, passwordInfoLabel: UILabel) -> Bool {
        guard self.count >= 6 else {
            passwordInfoLabel.text = ErrorStrings.passwordError
            passwordInfoLabel.isHidden = false
            passwordTextField.shake()

            return false
        }

        passwordInfoLabel.isHidden = true

        return true
    }

    func verifyEmail(emailTextField: UITextField, emailInfoLabel: UILabel) -> Bool {
        guard self.isValidEmail() else {
            emailInfoLabel.text = LoginSignUpStrings.invalidEmail
            emailInfoLabel.font = UIFont.wandaFontItalic(size: 10)
            emailInfoLabel.textColor = .red
            emailTextField.shake()

            return false
        }

        emailInfoLabel.font = UIFont.wandaFontRegular(size: 10)
        emailInfoLabel.textColor = .white
        emailInfoLabel.text = LoginSignUpStrings.useEmailOnFile

        return true
    }

    private func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return emailTest.evaluate(with: self)
    }
}
