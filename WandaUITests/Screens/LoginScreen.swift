//
//  LoginScreen.swift
//  WandaUITests
//
//  Created by Courtney on 9/30/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

// to do could you make a func that takes the name of the var and uses it for the string
// lowercased and underscore - vice versa

class LoginScreen: Screen {
    // put all screen elements here
    // ex: labels, views
    // could also put common func here
    // ex: count of x
    // also store screen id aka title here as string constant
    let identifier = ""
    
    var wandaLogo: XCUIElement {
        return app.images["wanda_logo"]
    }
    
    var emailTextField: XCUIElement {
        return app.textFields["email_text_field"]
    }
    
    // to do the sign up screen doesnt need this nested view
    // can we get rid of it? would need to redo vc layout a bit
    private var passwordTextView: XCUIElement {
        return app.otherElements["password_text_view"]
    }
    
    var passwordTextField: XCUIElement {
        return passwordTextView.secureTextFields["password_text_field"]
    }
    
    var passwordIsHidden: Bool {
        return passwordTextView.secureTextFields.count > 0 ? true : false
    }
    
    var emailInfoLabel: XCUIElement {
        return app.staticTexts["email_info_label"]
    }
    
    var passwordInfoLabel: XCUIElement {
        return app.staticTexts["password_info_label"]
    }
    
    var emailIcon: XCUIElement {
        return app.images["email_icon"]
    }
    
    var passwordIcon: XCUIElement {
        return app.images["password_icon"]
    }
    
    // to do - ? - is it better use accessibility id or text for this? does it matter
    var forgotPasswordButton: XCUIElement {
        return app.buttons["forgot_password_button"]
    }
    
    var showHideButton: XCUIElement {
        return passwordTextView.buttons["show_hide_button"]
    }
    
    var loginButton: XCUIElement {
        return app.buttons["login_button"]
    }
    
    var activityIndicatorVisible: Bool {
        return app.activityIndicators.count > 0 ? true : false
    }
}
