//
//  ViewControllerFactory.swift
//  Wanda
//
//  Created by Bell, Courtney on 1/11/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import MessageUI
import UIKit

enum ContactUsType {
    case login
    case signUp
    case wandaClass
}

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
    static func makeWandaClassViewController(wandaClass: WandaClass, classType: ClassType) -> WandaClassViewController? {
        guard let wandaClassViewController = UIStoryboard(identifier: .wandaClass).instantiateViewController(withIdentifier: WandaClassViewController.storyboardIdentifier) as? WandaClassViewController else {
            return nil
        }

        wandaClassViewController.wandaClass = wandaClass
        wandaClassViewController.classType = classType

        return wandaClassViewController
    }

    /// The view controller that pops up when the user taps "Sign Up" on the "Login" screen.
    static func makeSignUpViewController() -> SignUpViewController? {
        return UIStoryboard(identifier: .signUp).instantiateViewController(
            withIdentifier: SignUpViewController.storyboardIdentifier ) as? SignUpViewController
    }
    
    static func makeLoginViewController() -> LoginViewController? {
        return UIStoryboard(identifier: .login).instantiateViewController(
            withIdentifier: LoginViewController.storyboardIdentifier ) as? LoginViewController
    }

    /// The view controller that appears when the user either successfully signs up for the app or makes a class reservation.
    static func makeWandaAlertController(_ alertType: WandaAlertType, delegate: WandaAlertViewDelegate) -> WandaAlertViewController? {
        guard let wandaAlertViewController = UIStoryboard(identifier: .wandaAlert).instantiateViewController(withIdentifier: WandaAlertViewController.storyboardIdentifier) as? WandaAlertViewController else {
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

    /// The view controller that appears when the user taps contact us the mail app will open and pre-fill an email.
    static func makeContactUsViewController(for contactUsType: ContactUsType) -> MFMailComposeViewController? {
        guard MFMailComposeViewController.canSendMail() else {
            return nil
        }

        let emailComposeViewController = MFMailComposeViewController()

        switch contactUsType {
            case .login:
                emailComposeViewController.setToRecipients([WandaConstants.wandaSupportEmail])
                emailComposeViewController.setSubject("Login Help")
            case .signUp:
                emailComposeViewController.setToRecipients([WandaConstants.wandaSupportEmail])
                emailComposeViewController.setSubject("Sign Up Help")
            case .wandaClass:
                // Since the class email needs details specific to that class we set the subject and the message body in the ReservationViewController
                emailComposeViewController.setToRecipients([WandaConstants.jenniferEmail])
        }

        return emailComposeViewController
    }
}
