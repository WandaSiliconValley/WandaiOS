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
    case editProfile
    case forgotPassword
    case login
    case profile
    case signUp
    case wandaAlert
    case wandaClass
    case wandaSuccess
}

extension UIStoryboard {
    convenience init(identifier: WandaStoryboardIdentifier) {
        switch identifier {
            case .classes:
                self.init(name: ClassesViewController.storyboardIdentifier, bundle: Bundle(for: ClassesViewController.self))
            case .editProfile:
                   self.init(name: EditProfileViewController.storyboardIdentifier, bundle: Bundle(for: EditProfileViewController.self))
            case .forgotPassword:
                self.init(name: ForgotPasswordViewController.storyboardIdentifier, bundle: Bundle(for: ForgotPasswordViewController.self))
            case .login:
                self.init(name: LoginViewController.storyboardIdentifier, bundle: Bundle(for: LoginViewController.self))
            case .profile:
                self.init(name: ProfileViewController.storyboardIdentifier, bundle: Bundle(for: ProfileViewController.self))
            case .signUp:
                self.init(name: SignUpViewController.storyboardIdentifier, bundle: Bundle(for: SignUpViewController.self))
            case .wandaAlert:
                self.init(name: WandaAlertViewController.storyboardIdentifier, bundle: Bundle(for: WandaAlertViewController.self))
            case .wandaClass:
                self.init(name: WandaClassViewController.storyboardIdentifier, bundle: Bundle(for: WandaClassViewController.self))
            case .wandaSuccess:
                self.init(name: WandaSuccessViewController.storyboardIdentifier, bundle: Bundle(for: WandaSuccessViewController.self))
        }
    }
}
