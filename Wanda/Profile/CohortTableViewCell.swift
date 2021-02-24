//
//  CohortTableViewCell.swift
//  Wanda
//
//  Created by Courtney Bell on 2/21/21.
//  Copyright © 2021 Bell, Courtney. All rights reserved.
//

import Foundation
import UIKit

class CohortTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    static var cellNib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    class func nibName() -> String {
        return String(describing: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .clear
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }
}
