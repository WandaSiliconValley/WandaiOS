//
//  WandaImages.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/22/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation
import UIKit

struct WandaImages {
    static fileprivate let bundle = Bundle.main

    fileprivate struct ImageName {
        static let backArrow = "BackArrow"
        static let closeIcon = "CloseIcon"
        static let overflowIcon = "OverflowIcon"
        static let successCalendar = "SuccessCalendar"
        static let successEmail = "SuccessEmail"
    }

    static let backArrow = UIImage(named: ImageName.backArrow, in: bundle, compatibleWith: nil)
    static let closeIcon = UIImage(named: ImageName.closeIcon, in: bundle, compatibleWith: nil)
    static let overflowIcon = UIImage(named: ImageName.overflowIcon, in: bundle, compatibleWith: nil)
    static let successCalendar = UIImage(named: ImageName.successCalendar, in: bundle, compatibleWith: nil)
    static let successEmail = UIImage(named: ImageName.successEmail, in: bundle, compatibleWith: nil)
}
