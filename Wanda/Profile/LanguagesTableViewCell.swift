//
//  LanguagesTableViewCell.swift
//  Wanda
//
//  Created by Courtney Bell on 3/2/21.
//  Copyright © 2021 Bell, Courtney. All rights reserved.
//

import Foundation
import UIKit

class LanguagesTableViewCell: UITableViewCell {
    @IBOutlet weak var languageLabel: UILabel!
    
    static var cellNib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    class func nibName() -> String {
        return String(describing: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .orange
//        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
//        print("")
//        languageLabel.textColor = UIColor.black
//        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }
}
