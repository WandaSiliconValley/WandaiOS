//
//  ClassesHeaderView.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/25/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import UIKit

class ClassesHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private weak var sectionLabel: UILabel!

    static var cellNib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    class func nibName() -> String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundView = UIView(frame: self.bounds)
        backgroundView?.backgroundColor = WandaColors.lightGrey
    }

    func update(sectionText: String) {
        sectionLabel.text = sectionText
    }
}
