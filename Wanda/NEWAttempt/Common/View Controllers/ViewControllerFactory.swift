//
//  ViewControllerFactory.swift
//  Wanda
//
//  Created by Bell, Courtney on 1/11/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import UIKit

/// A collection of view controller instances.
struct ViewControllerFactory {
    private init() {}

    /// The view controller that pops up when the user either logins in or signs up
    /// that contains a list of all user classes.
    static func makeClassesViewController() -> ClassesViewController? {
        return UIStoryboard(identifier: .classes).instantiateViewController(withIdentifier: ClassesViewController.storyboardIdentifier) as? ClassesViewController
    }

    /// The view controller that pops up when the user taps "Forgot Password" on the "Login" screen.
    static func makeForgotPasswordController() -> ForgotPasswordViewController? {
        return UIStoryboard(identifier: .forgotPassword).instantiateViewController(withIdentifier: ForgotPasswordViewController.storyboardIdentifier) as? ForgotPasswordViewController
    }

    /// The view controller that pops up when the user taps the "Next Class" on the "Classes" screen.
    static func makeReservationViewController() -> ReservationViewController? {
        return UIStoryboard(identifier: .reservation).instantiateViewController(withIdentifier: ReservationViewController.storyboardIdentifier) as? ReservationViewController
    }

    /// The view controller that pops up when the user taps "Sign Up" on the "Login" screen.
    static func makeSignUpViewController() -> SignUpViewController? {
        return UIStoryboard(identifier: .signUp).instantiateViewController(
            withIdentifier: SignUpViewController.storyboardIdentifier ) as? SignUpViewController
    }

    /// The view controller that appears when the user either successfully signs up for the app or makes a class reservation.
    static func makeWandaAlertController(_ alertType: WandaAlertType, delegate: WandaAlertViewDelegate) -> WandaAlertViewController? {
        guard let wandaAlertViewController = UIStoryboard(identifier: .wandaAlert).instantiateViewController(withIdentifier: WandaAlertViewController.storyboardIdentifier) as? WandaAlertViewController else {
            assertionFailure("Could not instantiate WandaAlertViewController.")
            return nil
        }

        wandaAlertViewController.alertType = alertType
        wandaAlertViewController.delegate = delegate
        wandaAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        wandaAlertViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        return wandaAlertViewController
    }

    /// The view controller that appears when the user either successfully signs up for the app or makes a class reservation.
    static func makeWandaSuccessController() -> WandaSuccessViewController? {
        return UIStoryboard(identifier: .wandaSuccess).instantiateViewController(withIdentifier: WandaSuccessViewController.storyboardIdentifier) as? WandaSuccessViewController
    }
}
