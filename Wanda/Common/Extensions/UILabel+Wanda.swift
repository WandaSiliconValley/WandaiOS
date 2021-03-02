//
//  UILabel+Wanda.swift
//  Wanda
//
//  Created by Bell, Courtney on 3/25/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import UIKit

extension UILabel {
    func configureError(_ errorMessage: String, invalidTextField: UITextField) {
        self.isHidden = false
        self.text = errorMessage
        self.font = UIFont.wandaFontItalic(size: 12)
        self.textColor = WandaColors.newErrorRed
        invalidTextField.underlined(color: WandaColors.newErrorRed.cgColor)
        invalidTextField.shake()
    }

    func configureValidEmail(_ emailTextField:UITextField) {
        self.font = UIFont.wandaFontRegular(size: 12)
        self.textColor = WandaColors.mediumPurple
        self.text = LoginSignUpStrings.useEmailOnFile
        emailTextField.underlined()
    }
}
