//
//  LoginSignUpScreen.swift
//  WandaUITests
//
//  Created by Courtney on 11/23/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

class LoginSignUpScreen: Screen {
    let identifier = ""
    
    var wandaLogo: XCUIElement {
        return app.images["wanda_logo"]
    }
    
    var loginButton: XCUIElement {
        return app.buttons["loginsignup_login_button"]
    }
    
    var signUpButton: XCUIElement {
        return app.buttons["loginsignup_sign_up_button"]
    }
}
