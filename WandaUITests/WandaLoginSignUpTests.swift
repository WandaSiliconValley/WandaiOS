//
//  WandaUITests.swift
//  WandaUITests
//
//  Created by Courtney on 9/30/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

// to do figure out screenshots
// ex: labels, counts, button labels, visibility
// to do should we verify colors and fonts? etc
// to do - android can detect things that are unused can we do that?
// to do can we verify that the keyboard scrolls down? maybe checkign the
// visibility of the text field?

class WandaLoginSignUpTests: UITestCase {

    private let signUpScreen = SignUpScreen()
    private let forgotPasswordScreen = ForgotPasswordScreen()
    
    func testWandaLoginFunctionality() {
        verifyLoginSignUpUI()
        loginSignUpScreen.loginButton.tap()
        
        verifyWandaLoginUI()
        loginToWanda()
    }
    
    func testLoginErrors() {
        // You have to tap this first otherwise the pw label is hidden.
        loginSignUpScreen.loginButton.tap()
        loginScreen.loginButton.tap()

        let emailInfoLabel = loginScreen.emailInfoLabel
        let passwordInfoLabel = loginScreen.passwordInfoLabel
        
        let emailRequiredString = "Email Required"
        let passwordRequiredString = "Password Required"
        let notValidEmailString = "Not a valid email"
        let useEmailOnFileString = "Use email on file with WANDA"
                
        // CASE - email & pw empty
        XCTAssertEqual(emailInfoLabel.label, emailRequiredString)
        XCTAssertEqual(passwordInfoLabel.label, passwordRequiredString)
        
        // CASE - email incorrect & pw empty
        updateLoginInfo(email: "", password: nil)
        XCTAssertEqual(emailInfoLabel.label, notValidEmailString)
        XCTAssertEqual(passwordInfoLabel.label, passwordRequiredString)
        
        // CASE - email incorrect & pw short - dont want to tell them its short - security
        // to do - same case output as below - still worth testing?
        // if so add in a similiar case for all others - currently only here
        updateLoginInfo(email: nil, password: "")
        XCTAssertEqual(emailInfoLabel.label, notValidEmailString)
        XCTAssertFalse(passwordInfoLabel.exists)
        
        // CASE - email incorrect & pw correct
        updateLoginInfo(email: nil, password: "")
        XCTAssertEqual(emailInfoLabel.label, notValidEmailString)
        XCTAssertFalse(passwordInfoLabel.exists)

        // CASE - email empty & pw correct
        updateLoginInfo(email: "", password: nil)
        XCTAssertEqual(emailInfoLabel.label, emailRequiredString)
        XCTAssertFalse(passwordInfoLabel.exists)

        // CASE - email correct & pw empty
        updateLoginInfo(email: "", password: "")
        XCTAssertEqual(emailInfoLabel.label, useEmailOnFileString)
        XCTAssertEqual(passwordInfoLabel.label, passwordRequiredString)
        
        // CASE - email correct & pw correct
        updateLoginInfo(email: nil, password: "")
        XCTAssertEqual(emailInfoLabel.label, useEmailOnFileString)
        XCTAssertFalse(passwordInfoLabel.exists)
    }

    func testForgotPasswordScreen() {
        loginSignUpScreen.loginButton.tap()
        
        loginScreen.forgotPasswordButton.tap()
        
        verifyForgotPasswordUI()
        verifyForgotPasswordErrors()
        
        // to do - feel like there should be a better way to do this
        // without having to create a new let in situations like this - like android's apply?
        // you could apply the same concept anytime you have a handful of
        // things to do or verify on a single element.
        let emailTextField = forgotPasswordScreen.emailTextField
        emailTextField.tap()
        
        // We are using a fake email because we don't really want to spam someone with emails here.
        // We can't verify the email was received.
        // This also allows us to verify that the success alert appears even if an email is not registered.
        emailTextField.typeText("test@test.com")
        forgotPasswordScreen.resetPasswordButton.tap()
        
        let alert = AlertScreen()
        XCTAssertEqual(alert.title.label, "Success")
        XCTAssertEqual(alert.message.label, "An email was sent your way.")
        XCTAssertFalse(alert.buttonOne.exists)
        XCTAssertFalse(alert.buttonTwo.exists)
        XCTAssertTrue(alert.buttonThree.isHittable)
        XCTAssertEqual(alert.buttonThree.label, "DISMISS")
        
        alert.buttonThree.tap()
        screen.tapBackButton()
    }
    
    // Right now the most we can test the sign up screen is verifying the UI.
    // We have to add someone to the db before they can sign up so we should
    // wait until we have mocks to test the sign up functionality.
    func testSignUpUI() {
        loginSignUpScreen.signUpButton.tap()

        assertCurrentScreen(signUpScreen.identifier)
        XCTAssertNotNil(signUpScreen.wandaLogo)
        XCTAssertEqual(signUpScreen.emailTextField.placeholderValue, "Email")
        XCTAssertNotNil(signUpScreen.emailIcon)
        XCTAssertEqual(signUpScreen.emailInfoLabel.label, "Use email on file with WANDA")
        XCTAssertEqual(signUpScreen.passwordTextField.placeholderValue, "Password")
        XCTAssertNotNil(signUpScreen.passwordIcon)
        XCTAssertEqual(signUpScreen.confirmPasswordTextField.placeholderValue, "Confirm password")
        XCTAssertEqual(signUpScreen.signUpButton.label, "Sign Up")
    }
    
    // MARK - Helper Functions
    
    private func updateLoginInfo(email: String?, password: String?) {
        let emailTextField = loginScreen.emailTextField
        let passwordTextField = loginScreen.passwordTextField

        emailTextField.tap()
        if let email = email {
            emailTextField.clearAndEnterText(email)
        }
        
        passwordTextField.tap()
        if let password = password {
            passwordTextField.clearAndEnterText(password)
        }
        
        loginScreen.loginButton.tap()
    }

    private func verifyForgotPasswordErrors() {
        forgotPasswordScreen.resetPasswordButton.tap()
        XCTAssertEqual(forgotPasswordScreen.emailInfoLabel.label, "Email Required")
    }
    
    private func verifyForgotPasswordUI() {
        assertCurrentScreen(forgotPasswordScreen.identifier)
        XCTAssertNotNil(forgotPasswordScreen.wandaLogo)
        XCTAssertEqual(forgotPasswordScreen.emailTextField.placeholderValue, "Email")
        XCTAssertNotNil(forgotPasswordScreen.emailIcon)
        XCTAssertEqual(forgotPasswordScreen.emailInfoLabel.label, "Use email on file with WANDA")
        XCTAssertEqual(forgotPasswordScreen.resetPasswordButton.label, "RESET PASSWORD")
        XCTAssertEqual(forgotPasswordScreen.needHelpLabel.label, "Need help?")
        XCTAssertEqual(forgotPasswordScreen.contactSupportButton.label, "CONTACT SUPPORT")
    }
    
    private func verifyLoginSignUpUI() {
        XCTAssertNotNil(loginSignUpScreen.wandaLogo)
        XCTAssertEqual(loginSignUpScreen.loginButton.label, "Login")
        XCTAssertEqual(loginSignUpScreen.signUpButton.label, "Sign Up")
    }
    
    private func verifyWandaLoginUI() {
        // to do figure out how to do images! is this all we can check? Why does verifying the asset not work here?
        XCTAssertNotNil(loginScreen.wandaLogo)
        XCTAssertEqual(loginScreen.emailTextField.placeholderValue, "Email")
        XCTAssertNotNil(loginScreen.emailIcon)
        XCTAssertEqual(loginScreen.emailInfoLabel.label, "Use email on file with WANDA")
        XCTAssertEqual(loginScreen.passwordTextField.placeholderValue, "Password")
        XCTAssertEqual(loginScreen.forgotPasswordButton.label, "Forgot Password?")
        XCTAssertNotNil(loginScreen.passwordIcon)
        XCTAssertNotNil(loginScreen.showHideButton)
        XCTAssertEqual(loginScreen.loginButton.label, "Login")
    }
}
