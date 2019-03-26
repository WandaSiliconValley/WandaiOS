//
//  UIActivityIndicatorView+Wanda.swift
//  Wanda
//
//  Created by Bell, Courtney on 3/25/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import UIKit

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
