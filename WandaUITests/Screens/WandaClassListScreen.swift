//
//  WandaClassListScreen.swift
//  WandaUITests
//
//  Created by Courtney on 10/5/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

class WandaClassListScreen: Screen {
    // to do is this idenitifier valid or used
    let identifier = "Wanda.ClassesView"
    let title = "Class Schedule"
    
    var titleLabel: XCUIElement {
        return app.navigationBars.buttons[title]
    }
    
    var logoutButton: XCUIElement {
        return app.navigationBars.buttons["Logout"]
    }
    
    var nextClassTitle: XCUIElement {
        return app.staticTexts["NEXT CLASS"]
    }
    
    var upcomingClassTitle: XCUIElement {
        return app.staticTexts["UPCOMING CLASSES"]
    }
    
    // We are assuming that the first class is always the next class - this may not always be true until we have mocks.
    var nextClass: XCUIElement {
        return app.cells.firstMatch
    }
    
    // We are assuming that the second class is always an upcoming class - this may not always be true until we have mocks.
    var upcomingClass: XCUIElement {
        return app.cells.element(boundBy: 1)
    }
    
    var nextClassButton: XCUIElement {
        return getReserveASpotButton(nextClass)
    }
    
    var upcomingClassButton: XCUIElement {
        return getReserveASpotButton(upcomingClass)
    }
    
    var nextClassIsReservedLabel: XCUIElement {
        return getIsReservedLabel(nextClass)
    }
    
    var upcomingClassIsReservedLabl: XCUIElement {
        return getIsReservedLabel(upcomingClass)
    }
    
    private func getIsReservedLabel(_ classCell: XCUIElement) -> XCUIElement {
        return classCell.staticTexts["Your spot is reserved"]
    }
    
    private func getReserveASpotButton(_ classCell: XCUIElement) -> XCUIElement {
        return classCell.buttons["RESERVE A SPOT"]
    }
}
