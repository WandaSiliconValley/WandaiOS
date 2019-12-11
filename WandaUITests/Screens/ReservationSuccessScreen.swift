//
//  ReservationSuccessScreen.swift
//  WandaUITests
//
//  Created by Courtney on 12/5/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

class ReservationSuccessScreen: Screen {
    var successIcon: XCUIElement {
        return app.images["success_image"]
    }
    
    var successTitle: XCUIElement {
        return app.staticTexts["success_title"]
    }
    
    var successMessage: XCUIElement {
        return app.staticTexts["success_message"]
    }
    
    var closeButton: XCUIElement {
        return app.navigationBars.buttons["CloseIcon"]
    }
}
