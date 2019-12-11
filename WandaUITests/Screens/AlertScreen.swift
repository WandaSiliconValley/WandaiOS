//
//  AlertScreen.swift
//  WandaUITests
//
//  Created by Courtney on 10/5/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

class AlertScreen: Screen {
    var title: XCUIElement {
        return app.staticTexts["alert_title"]
    }
    
    var message: XCUIElement {
        return app.staticTexts["alert_message"]
    }
    
    var buttonOne: XCUIElement {
        return app.buttons["alert_button_one"]
    }
    
    var buttonTwo: XCUIElement {
        return app.buttons["alert_button_two"]
    }
    
    var buttonThree: XCUIElement {
        return app.buttons["alert_button_three"]
    }
}
