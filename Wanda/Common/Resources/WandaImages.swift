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
        static let envelopeFilledIcon = "EnvelopeFilledIcon"
        static let eyeIcon = "EyeIcon"
        static let eyeOffIcon = "EyeOffIcon"
        static let languagesIcon = "LanguagesIcon"
        static let networkConnectionIcon = "NetworkConnectionIcon"
        static let overflowIcon = "OverflowIcon"
        static let person = "Person"
        static let phoneIcon = "PhoneIcon"
        static let successCalendar = "SuccessCalendar"
        static let successEmail = "SuccessEmail"
        static let wandaLogo = "WandaLogo"
    }

    static let backArrow = UIImage(named: ImageName.backArrow, in: bundle, compatibleWith: nil)
    static let closeIcon = UIImage(named: ImageName.closeIcon, in: bundle, compatibleWith: nil)
    static let envelopeFilledIcon = UIImage(named: ImageName.envelopeFilledIcon, in: bundle, compatibleWith: nil)
    static let eyeIcon = UIImage(named: ImageName.eyeIcon, in: bundle, compatibleWith: nil)
    static let eyeOffIcon = UIImage(named: ImageName.eyeOffIcon, in: bundle, compatibleWith: nil)
    static let languagesIcon = UIImage(named: ImageName.languagesIcon, in: bundle, compatibleWith: nil)
    static let networkConnectionIcon = UIImage(named: ImageName.networkConnectionIcon, in: bundle, compatibleWith: nil)
    static let overflowIcon = UIImage(named: ImageName.overflowIcon, in: bundle, compatibleWith: nil)
    static let person = UIImage(named: ImageName.person, in: bundle, compatibleWith: nil)
    static let phoneIcon = UIImage(named: ImageName.phoneIcon, in: bundle, compatibleWith: nil)
    static let successCalendar = UIImage(named: ImageName.successCalendar, in: bundle, compatibleWith: nil)
    static let successEmail = UIImage(named: ImageName.successEmail, in: bundle, compatibleWith: nil)
    static let wandaLogo = UIImage(named: ImageName.wandaLogo, in: bundle, compatibleWith: nil)
}
