//
//  SignUpScreen.swift
//  WandaUITests
//
//  Created by Courtney on 9/30/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

class SignUpScreen: Screen {
    let identifier = "SIGN UP"
    
    // to do is there a better way to find these elements
    // other than adding the same id on each vc?
    var wandaLogo: XCUIElement {
        return app.images["su_wanda_logo"]
    }
    
    // to do needed to preface these with su b/c it was seeing the
    // same id on the login screen that is underneath the sign up screen
    // is there a better way to get around this?
    var emailTextField: XCUIElement {
        return app.textFields["su_email_text_field"]
    }
    
    var passwordTextField: XCUIElement {
        return app.secureTextFields["su_password_text_field"]
    }
    
    var confirmPasswordTextField: XCUIElement {
        return app.secureTextFields["confirm_password_text_field"]
    }
    
    var passwordIsHidden: Bool {
        return passwordTextField.secureTextFields.count > 0 ? true : false
    }
    
    var emailInfoLabel: XCUIElement {
        return app.staticTexts["su_email_info_label"]
    }
    
    var passwordShowHideButton: XCUIElement {
        return app.buttons["su_password_show_hide"]
    }
    
    var confirmPasswordShowHideButton: XCUIElement {
        return app.buttons["confirm_show_hide"]
    }
    
    var signUpButton: XCUIElement {
        return app.buttons["sign_up_button"]
    }
    
    var activityIndicatorVisible: Bool {
        return app.activityIndicators.count > 0 ? true : false
    }
    
    var emailIcon: XCUIElement {
        return app.images["email_icon"]
    }
    
    var passwordIcon: XCUIElement {
        return app.images["password_icon"]
    }
}
