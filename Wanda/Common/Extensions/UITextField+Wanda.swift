//
//  UITextField+Wanda.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/22/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import UIKit

extension UITextField {
    func underlined(color: CGColor? = UIColor.white.cgColor){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        print("UNDERLINE \(border.frame)")
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
