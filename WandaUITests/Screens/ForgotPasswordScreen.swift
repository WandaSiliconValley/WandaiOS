//
//  ForgotPasswordScreen.swift
//  WandaUITests
//
//  Created by Courtney on 10/1/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

// where should i put common elements like the logo and email text field t
// or should we just have a general login flow screen?

class ForgotPasswordScreen: Screen {
    let identifier = "FORGOT PASSWORD"
    
    var wandaLogo: XCUIElement {
        return app.images["fp_wanda_logo"]
    }
    
    var emailTextField: XCUIElement {
        return app.textFields["fp_email_text_field"]
    }
    
    var emailInfoLabel: XCUIElement {
        return app.staticTexts["fp_email_info_label"]
    }
    
    var emailIcon: XCUIElement {
        return app.images["fp_email_icon"]
    }
    
    var resetPasswordButton: XCUIElement {
        return app.buttons["reset_password_button"]
    }
    
    var needHelpLabel: XCUIElement {
        return app.staticTexts["fp_need_help_label"]
    }
    
    var contactSupportButton: XCUIElement {
        return app.buttons["fp_contact_support_button"]
    }
}
