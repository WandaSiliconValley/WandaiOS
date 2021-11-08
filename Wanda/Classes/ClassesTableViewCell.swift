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
    @IBOutlet weak var classDescriptionView: UIView!
    @IBOutlet private weak var classLocationLabel: UILabel!
    @IBOutlet private weak var classTopicLabel: UILabel!
    @IBOutlet private weak var classTimeLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet weak var isReservedIcon: UIImageView!
    @IBOutlet weak var isReservedLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet weak var reservationButton: UIButton!
    @IBOutlet weak var reservedView: UIView!

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
    
    func configureClass(_ wandaClass: WandaClass, isNextClass: Bool) {
        guard let eventDate = DateFormatter.simpleDateFormatter.date(from: wandaClass.details.date) else {
            return
        }

        let calendar = Calendar.current
        let month = DateFormatter.shortMonthDateFormatter.string(from: eventDate)
        let day = calendar.component(.day, from: eventDate)

        dayLabel.text = String(day)
        monthLabel.text = month.uppercased()

        classTopicLabel.text = wandaClass.details.topic
        classTimeLabel.text = wandaClass.details.time
        classLocationLabel.text = wandaClass.details.address
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: eventDate, to: Date()).day ?? 0
        if numberOfDays <= 7 {
            reservationButton.isHidden = true
            reservedView.isHidden = true
            
                switch wandaClass.isReserved {
                    case true:
                        reservationButton.isHidden = true
                        reservedView.isHidden = false
                    case false:
                        reservationButton.isHidden = false
                        reservedView.isHidden = true
                }
        } else {
            reservationButton.isHidden = true
            reservedView.isHidden = true
        }
        
        if isNextClass {
            classDescriptionView.layer.applySketchShadow(alpha: 0, y: 0, blur: 0)
        } else {
            classDescriptionView.layer.applySketchShadow(alpha: 0.1, y: 1, blur: 2)
        }
    }
}
