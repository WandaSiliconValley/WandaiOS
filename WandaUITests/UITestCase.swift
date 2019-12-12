//
//  UITestCase.swift
//  WandaUITests
//
//  Created by Courtney on 9/30/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

open class UITestCase: XCTestCase {
    let app = XCUIApplication()
    let screen = Screen()
    let loginSignUpScreen = LoginSignUpScreen()
    let loginScreen = LoginScreen()
    
    // to do - to use the existing class type we need to import Wanda
    // to import Wanda we need to add the Firebase pod to this target
    // is it really worth it to add an additional pod to the tests just for this?
    // guess it doesn't hurt since they don't get included anyways
    enum ClassType {
         case nextClass
         case upcomingClass
     }
    
    private var currentScreenIdentifier: String {
        return screen.navigationBar.identifier
    }

    override open func setUp() {
        continueAfterFailure = false
        
        app.launch()
    }
    
    // to do understand this
    // is this really that beneficial when there is already a waitForElementToAppear?
    // benefit - this specifies file/line
    public func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 30, file: StaticString = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout) { error in
            if error != nil {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: String(describing: file), atLine: Int(line), expected: true)
            }
        }
    }
    
    func assertCurrentScreen(_ screenIdentifier: String) {
        XCTAssertEqual(currentScreenIdentifier, screenIdentifier)
    }
    
    func waitForScreen(_ screenIdentifier: String, timeout: TimeInterval = 30, file: StaticString = #file, line: UInt = #line) {
        let titleElement = app.navigationBars[screenIdentifier]
        waitForElementToAppear(titleElement, timeout: timeout, file: file, line: line)
    }
    
    func loginToWanda() {
        let emailTextField = loginScreen.emailTextField
        emailTextField.tap()
        emailTextField.typeText("")
        
        let pwTextField = loginScreen.passwordTextField
        pwTextField.tap()
        pwTextField.typeText("")
        
        // Ensure pw is hidden.
        XCTAssertTrue(loginScreen.passwordIsHidden)
        
        // Ensure tapping the show hide button unhides the pw.
        loginScreen.showHideButton.tap()
        XCTAssertFalse(loginScreen.passwordIsHidden)
        
        // Ensure tapping the show hide button again rehides the pw.
        loginScreen.showHideButton.tap()
        XCTAssertTrue(loginScreen.passwordIsHidden)
        
        // Ensure the activity Indicator is hidden and appears when the user taps the login button.
        XCTAssertFalse(loginScreen.activityIndicatorVisible)
        loginScreen.loginButton.tap()
        XCTAssertTrue(loginScreen.activityIndicatorVisible)
        
        let classListScreen = WandaClassListScreen()
        waitForScreen(classListScreen.identifier)
        XCTAssertTrue(classListScreen.navigationBar.buttons[classListScreen.title].exists)
    }
}
