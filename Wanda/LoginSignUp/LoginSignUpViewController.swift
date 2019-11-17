//
//  LoginSignUpViewController.swift
//  
//
//  Created by Courtney on 10/16/19.
//

import UIKit

class LoginSignUpViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.isTranslucent = true
        }
        print("UMMM")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HIIII")
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80.0)
        }
    }
    
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
