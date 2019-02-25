//
//  UIStoryboard+Wanda.swift
//  Wanda
//
//  Created by Bell, Courtney on 1/11/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import UIKit

/// A collection of storyboard identifiers.
enum WandaStoryboardIdentifier {
    case classes
    case forgotPassword
    case reservation
    case signUp
    case wandaAlert
    case wandaSuccess
}

extension UIStoryboard {
    convenience init(identifier: WandaStoryboardIdentifier) {
        switch identifier {
            case .classes:
                self.init(name: ClassesViewController.storyboardIdentifier, bundle: Bundle(for: ClassesViewController.self))
            case .forgotPassword:
                self.init(name: ForgotPasswordViewController.storyboardIdentifier, bundle: Bundle(for: ForgotPasswordViewController.self))
            case .reservation:
                self.init(name: ReservationViewController.storyboardIdentifier, bundle: Bundle(for: ReservationViewController.self))
            case .signUp:
                self.init(name: SignUpViewController.storyboardIdentifier, bundle: Bundle(for: SignUpViewController.self))
            case .wandaAlert:
                self.init(name: WandaAlertViewController.storyboardIdentifier, bundle: Bundle(for: WandaAlertViewController.self))
            case .wandaSuccess:
                self.init(name: WandaSuccessViewController.storyboardIdentifier, bundle: Bundle(for: WandaSuccessViewController.self))
        }
    }
}
