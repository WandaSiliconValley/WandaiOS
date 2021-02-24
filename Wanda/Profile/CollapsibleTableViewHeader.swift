//
//  CollapsibleTableViewHeader.swift
//  Wanda
//
//  Created by Courtney Bell on 2/17/21.
//  Copyright © 2021 Bell, Courtney. All rights reserved.
//

import Foundation
import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    @IBOutlet weak var arrowImage: UIImageView!
//    let titleLabel = UILabel()
//    let arrowLabel = UILabel()
    
    static var cellNib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    class func nibName() -> String {
        return String(describing: self)
    }
//
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//
//        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader)))
//
//        // arrowLabel must have fixed width and height
////        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
////        arrowLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
////        titleLabel.translatesAutoresizingMaskIntoConstraints = false
////        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
//    }

    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    @objc
    func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        delegate?.toggleSection(self, section: cell.section)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        arrowImage.widthAnchor.constraint(equalToConstant: 14).isActive = true
        arrowImage.heightAnchor.constraint(equalToConstant: 6).isActive = true
        arrowImage.translatesAutoresizingMaskIntoConstraints = false

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader)))
    }
    
    func setCollapsed(collapsed: Bool) {
        print("TESTANG")
        self.arrowImage.transform = self.arrowImage.transform.rotated(by: .pi)
    }
}
