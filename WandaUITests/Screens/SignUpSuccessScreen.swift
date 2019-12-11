//
//  SignUpSuccessScreen.swift
//  WandaUITests
//
//  Created by Courtney on 10/13/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

class SignUpSuccessScreen: Screen {
    var successImage: XCUIElement {
        return app.images["success_image"]
    }
    
    var successTitle: XCUIElement {
        return app.staticTexts["success_title"]
    }
    
    var successText: XCUIElement {
        return app.staticTexts["success_text"]
    }
    
    var successButton: XCUIElement {
        return app.buttons["success_button"]
    }
}
