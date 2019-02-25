//
//  ClassesTableViewCell.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/25/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import UIKit

// TODO will want to pass completion block? or just utilize class name to get to the right reservation screen??
// Is this the proper place to put the action
class ClassesTableViewCell: UITableViewCell {
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var classNameLabel: UILabel!
    @IBOutlet private weak var classTimeLabel: UILabel!
    @IBOutlet private weak var classLocationLabel: UILabel!
    @IBOutlet weak var reservationButton: UIButton!
    @IBOutlet weak var reservedView: UIView!
    @IBOutlet weak var isReservedIcon: UIImageView!

    @IBOutlet weak var isReservedLabel: UILabel!
    static var cellNib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    class func nibName() -> String {
        return String(describing: self)
    }
    
    func configureClass(_ wandaClass: WandaClassInfo) {
        classNameLabel.text = wandaClass.topic // to do maybe update me to name?
        classTimeLabel.text = wandaClass.time
        classLocationLabel.text = wandaClass.address

        switch wandaClass.isReserved {
            case true:
                reservationButton.isHidden = true
                reservedView.isHidden = false
            case false:
                reservationButton.isHidden = false
                reservedView.isHidden = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.backgroundColor = .clear
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }
}
