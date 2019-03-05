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
    func isPasswordValid(passwordTextField: UITextField, passwordInfoLabel: UILabel) -> Bool {
        if self.isEmpty {
            passwordInfoLabel.configureError(ErrorStrings.passwordRequired, invalidTextField: passwordTextField)
            return false
        } else if self.count <= 6 {
            passwordInfoLabel.configureError(ErrorStrings.passwordError, invalidTextField: passwordTextField)
            return false
        }

        return true
    }

    func isEmailValid(emailTextField: UITextField, emailInfoLabel: UILabel) -> Bool {
        if self.isEmpty {
            emailInfoLabel.configureError(ErrorStrings.emailRequired, invalidTextField: emailTextField)

            return false
        } else if !self.validEmail() {
            emailInfoLabel.configureError(LoginSignUpStrings.invalidEmail, invalidTextField: emailTextField)

            return false
        }

        emailInfoLabel.configureValidEmail(emailTextField)

        return true
    }

    private func validEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return email.evaluate(with: self)
    }
}
