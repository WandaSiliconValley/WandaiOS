//
//  Screen.swift
//  WandaUITests
//
//  Created by Courtney on 9/30/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

open class Screen {
    public let app = XCUIApplication()

    // put all common screen elements and actions here
    // ex: back button, nav bar
    // ex: dismiss, goback, dismiss keyboard, search, etc.

    public var navigationBar: XCUIElement {
        return app.navigationBars.firstMatch
    }
    
    // to do do we really need this or do we just need the tap functionality?
    public var backButton: XCUIElement {
        return navigationBar.buttons["BackArrow"]
    }
    
    public func tapBackButton() {
        // to do is there really a point to this assert since if you can tap it, it exists?
        XCTAssertTrue(backButton.exists)
        backButton.tap()
    }
}

// to do move me

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(_ text: String) {
        clearText()
        self.typeText(text)
    }
    
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }

        // to do understand this better
        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        self.typeText(deleteString)
    }
}
