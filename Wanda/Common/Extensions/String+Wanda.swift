//
//  String+Wanda.swift
//  Wanda
//
//  Created by Bell, Courtney on 1/5/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isCellPhoneValid(cellPhoneTextField: UITextField, cellPhoneInfoLabel: UILabel, isValid: Bool) -> Void {
        if !isValid {
            cellPhoneInfoLabel.configureError("Please enter a valid phone number", invalidTextField: cellPhoneTextField, true)

            return
        }

        cellPhoneInfoLabel.configureValidEmail(cellPhoneTextField)
    }
    
    func isNameValid(nameTextField: UITextField, nameInfoLabel: UILabel, isValid: Bool) -> Void {
        if !isValid {
            nameInfoLabel.configureError("Name is required", invalidTextField: nameTextField, true)
            return
        }
    }
    
    func isEmailValid(emailTextField: UITextField, emailInfoLabel: UILabel, shake: Bool = true) -> Bool {
        if self.isEmpty {
            emailInfoLabel.configureError(ErrorStrings.emailRequired, invalidTextField: emailTextField, shake)

            return false
        } else if !self.validEmail() {
            emailInfoLabel.configureError(LoginSignUpStrings.invalidEmail, invalidTextField: emailTextField, shake)

            return false
        }

        emailInfoLabel.configureValidEmail(emailTextField)

        return true
    }

    func isPasswordValid(passwordTextField: UITextField, passwordInfoLabel: UILabel, checkLength: Bool) -> Bool {
        if self.isEmpty {
            passwordInfoLabel.configureError(ErrorStrings.passwordRequired, invalidTextField: passwordTextField)
            return false
        } else if self.count <= 6 && checkLength {
            passwordInfoLabel.configureError(ErrorStrings.passwordError, invalidTextField: passwordTextField)
            return false
        }

        return true
    }

    private func validEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return email.evaluate(with: self)
    }
}
