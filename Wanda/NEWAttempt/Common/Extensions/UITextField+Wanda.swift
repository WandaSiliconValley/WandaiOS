//
//  UITextField+Wanda.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/22/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func underlined(color: CGColor? = UIColor.white.cgColor){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }


}

extension UILabel {
    func configureError(_ errorMessage: String, invalidTextField: UITextField) {
        self.isHidden = false
        self.text = errorMessage
        self.font = UIFont.wandaFontItalic(size: 10)
        self.textColor = .red
        invalidTextField.underlined(color: UIColor.red.cgColor)
        invalidTextField.shake()
    }

    func configureValidEmail(_ emailTextField:UITextField) {
        self.font = UIFont.wandaFontRegular(size: 10)
        self.textColor = .white
        self.text = LoginSignUpStrings.useEmailOnFile
        emailTextField.underlined(color: UIColor.white.cgColor)
    }
}

extension UIActivityIndicatorView {
    func toggleSpinner(for button: UIButton, title: String) {
        self.isHidden = !self.isHidden
        if self.isHidden {
            self.stopAnimating()
        } else {
            self.startAnimating()
        }
        let loginButtonTitle = self.isHidden ? title : ""
        button.setTitle(loginButtonTitle, for: .normal)
    }
}
