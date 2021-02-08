//
//  UITextField+Wanda.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/22/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addImage(_ imageRect: CGRect, _ image: UIImage?) {
        let imageView = UIImageView(frame: imageRect)
             imageView.image = image
         let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
         imageContainerView.addSubview(imageView)
         leftView = imageContainerView
         leftViewMode = .always
    }
}
