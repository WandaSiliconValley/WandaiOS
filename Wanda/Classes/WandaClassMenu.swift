//
//  WandaClassMenu.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/20/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//
import Foundation
import UIKit
class WandaClassMenu: UIView {
    @IBOutlet var addToCalendarButton: UIButton!
    @IBOutlet var contactUsButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var menuView: [UIView]!
    var view: UIView?

    class func nibName() -> String {
        return String(describing: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func toggleMenu() {
        var isHidden = false
        DispatchQueue.main.async {
            self.contentView.isHidden = !self.contentView.isHidden
            self.menuView.forEach { menuItem in
                menuItem.isHidden = !menuItem.isHidden
                isHidden = menuItem.isHidden
            }
            
            if isHidden {
                self.bringSubview(toFront: self.contentView)
            } else {
                self.sendSubview(toBack: self.contentView)
            }
        }
    }

    // MARK: Private
    private func commonInit() {
        Bundle.main.loadNibNamed(WandaClassMenu.nibName(), owner: self, options: nil)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.isHidden = true
        contentView.layer.applySketchShadow(alpha: 0.22, y: 15, blur: 12)
        contentView.layer.applySketchShadow(alpha: 0.3, y: 19, blur: 38)
    }
}
