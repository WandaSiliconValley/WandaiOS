//
//  LoginSignUpViewController.swift
//  
//
//  Created by Courtney on 10/16/19.
//

import UIKit

class LoginSignUpViewController: UIViewController {
    
    @IBAction func didTapSignUp() {
        guard let signUpViewController = ViewControllerFactory.makeSignUpViewController() else {
            assertionFailure("Could not load the SignUpViewController.")
            return
        }
        
//        logAnalytic(tag: WandaAnalytics.loginSignUpButtonTapped)
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @IBAction func didTapLogin() {
        guard let loginViewController = ViewControllerFactory.makeLoginViewController() else {
            assertionFailure("Could not load the LoginViewController.")
            return
        }
        
//        logAnalytic(tag: WandaAnalytics.loginSignUpButtonTapped)
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }

}
