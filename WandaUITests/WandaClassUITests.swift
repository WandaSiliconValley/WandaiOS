//
//  WandaClassUITests.swift
//  WandaUITests
//
//  Created by Courtney on 12/6/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

// to do - what's the diff between true for exists and not nil
// based on testing only - seems that an element will be not nil whether
// it is visible or not but an item only exists if it is visible. research this more
// to do - can i assert the screen even tho it doesnt have a title - accessibility id?

// These tests have to run in order or they won't work - until mocks.
class WandaClassUITests: UITestCase {
    private let alert = AlertScreen()
    private let classScreen = WandaClassListScreen()
    private let classDetailScreen = ClassDetailScreen()
    private let reservationSuccessScreen = ReservationSuccessScreen()
    
    func testUpcomingClassUI() {
        loginSignUpScreen.loginButton.tap()
        loginToWanda()
        
        verifyClassListUI(hasReservation: false)
        classScreen.upcomingClass.tap()
        verifyClassDetailUI(classType: ClassType.upcomingClass, isReserved: false)
    }
    
    func testClassSignUp() {
        loginSignUpScreen.loginButton.tap()
        loginToWanda()
        
        verifyClassListUI(hasReservation: false)
        classScreen.nextClassButton.tap()
        
        verifyClassDetailUI(classType: ClassType.nextClass, isReserved: false)
        classDetailScreen.reserveMySpotButton.tap()
        
        verifyReservationSuccessUI()
        reservationSuccessScreen.closeButton.tap()
        
        verifyClassListUI(hasReservation: true)
        classScreen.nextClass.tap()
        
        verifyClassDetailUI(classType: ClassType.nextClass, isReserved: true)
    }
    
    func testUpdateClassReservation() {
        loginSignUpScreen.loginButton.tap()
        loginToWanda()
        
        verifyClassListUI(hasReservation: true)
        classScreen.nextClass.tap()
        
        verifyClassDetailUI(classType: ClassType.nextClass, isReserved: true)
        classDetailScreen.changeRSVPButton.tap()
        XCTAssertFalse(classDetailScreen.updateRSVPButton.isEnabled)
        XCTAssertEqual(classDetailScreen.numberOfChildrenlabel.label, "0")
        classDetailScreen.addChildButton.tap()
        XCTAssertEqual(classDetailScreen.numberOfChildrenlabel.label, "1")
        classDetailScreen.updateRSVPButton.tap()
        
        verifyReservationSuccessUI()
        reservationSuccessScreen.closeButton.tap()
        
        verifyClassListUI(hasReservation: true)
        classScreen.nextClass.tap()
        
        verifyClassDetailUI(classType: ClassType.nextClass, isReserved: true)
        XCTAssertEqual(classDetailScreen.numberOfChildrenlabel.label, "1")
    }
    
    func testCancelClassReservation() {
        loginSignUpScreen.loginButton.tap()
        loginToWanda()
        
        verifyClassListUI(hasReservation: true)
        classScreen.nextClass.tap()
        
        verifyClassDetailUI(classType: ClassType.nextClass, isReserved: true)
        classDetailScreen.cancelReservationButton.tap()
        verifyCancelClassDialogueAndContiue()
        
        verifyClassListUI(hasReservation: false)
        classScreen.nextClass.tap()
        
        verifyClassDetailUI(classType: ClassType.nextClass, isReserved: false)
    }
    
    func testDiscardChanges() {
        loginSignUpScreen.loginButton.tap()
        loginToWanda()
        
        verifyClassListUI(hasReservation: false)
        classScreen.nextClass.tap()
        
        verifyClassDetailUI(classType: ClassType.nextClass, isReserved: false)
        XCTAssertEqual(classDetailScreen.numberOfChildrenlabel.label, "0")
        classDetailScreen.addChildButton.tap()
        XCTAssertEqual(classDetailScreen.numberOfChildrenlabel.label, "1")
        
        classDetailScreen.backButton.tap()
        verifyDiscardChangesDialogue()
        // Tap Keep working and verify your changes are still present.
        alert.buttonTwo.tap()
        verifyClassDetailUI(classType: ClassType.nextClass, isReserved: false)
        XCTAssertEqual(classDetailScreen.numberOfChildrenlabel.label, "1")

        classDetailScreen.backButton.tap()
        verifyDiscardChangesDialogue()
        // Tap Discard changes and verify you returned to the classes list.
        alert.buttonThree.tap()
        verifyClassListUI(hasReservation: false)
    }
    
    func testAddToCalendarAndContactUs() {
        loginSignUpScreen.loginButton.tap()
        loginToWanda()
        
        verifyClassListUI(hasReservation: false)
        classScreen.nextClass.tap()
        
        verifyClassDetailUI(classType: ClassType.nextClass, isReserved: false)
        classDetailScreen.overflowMenu.tap()
        
        // Unfortunately, the most of Contact Us we can test is this.
        // The Mail app doesn't exist on iOS simulator so this functionality must be tested on device.
        // to do - should there be a UI test for this anyways? we can always run it manually
        XCTAssertTrue(classDetailScreen.contactUsButton.exists)
        classDetailScreen.addToCalendarButton.tap()
        addUIInterruptionMonitor(withDescription: "System Dialogue") { (alert) -> Bool in
            let button = alert.buttons["OK"]
            if button.exists {
                button.tap()
                return true
            }
            
            return false
        }
        
        app.tap()
        // We're verifying the calendar opened based on this label existing.
        let travelTimeLabel = app.staticTexts["Travel Time"]
        XCTAssertTrue(travelTimeLabel.exists)
        
        // to do - once mocks are set up we can verify the text that is put into the event.
    }
    
    // MARK - Helper Functions
    
    private func verifyClassDetailUI(classType: ClassType, isReserved: Bool) {
        XCTAssertTrue(classDetailScreen.dateLabel.exists)
        XCTAssertTrue(classDetailScreen.timeLabel.exists)
        XCTAssertTrue(classDetailScreen.dateTimeIcon.exists)
        
        XCTAssertTrue(classDetailScreen.locationNameLabel.exists)
        XCTAssertTrue(classDetailScreen.addressLabel.exists)
        XCTAssertTrue(classDetailScreen.locationIcon.exists)
        
        // to do improve this
        if classType == ClassType.nextClass {
            XCTAssertTrue(classDetailScreen.childCareLabel.exists)
            XCTAssertTrue(classDetailScreen.howManyChildrenLabel.exists)
            XCTAssertTrue(classDetailScreen.childCareIcon.exists)
            XCTAssertTrue(classDetailScreen.removeChildButton.exists)
            XCTAssertTrue(classDetailScreen.numberOfChildrenlabel.exists)
            XCTAssertTrue(classDetailScreen.addChildButton.exists)

            if !isReserved {
                XCTAssertTrue(classDetailScreen.reserveMySpotButton.exists)
                XCTAssertFalse(classDetailScreen.changeRSVPButton.exists)
                XCTAssertFalse(classDetailScreen.cancelReservationButton.exists)
                XCTAssertFalse(classDetailScreen.reservedIcon.exists)
                XCTAssertFalse(classDetailScreen.spotIsReservedLabel.exists)
                XCTAssertFalse(classDetailScreen.reservedOverlayView.exists)
            } else {
                XCTAssertFalse(classDetailScreen.reserveMySpotButton.exists)
                XCTAssertTrue(classDetailScreen.changeRSVPButton.exists)
                XCTAssertTrue(classDetailScreen.cancelReservationButton.exists)
                XCTAssertTrue(classDetailScreen.reservedIcon.exists)
                XCTAssertTrue(classDetailScreen.spotIsReservedLabel.exists)
                XCTAssertTrue(classDetailScreen.reservedOverlayView.exists)
            }
            
            // to do add check that buttons are dis/enabled
        } else if classType == ClassType.upcomingClass {
            XCTAssertFalse(classDetailScreen.childCareLabel.exists)
            XCTAssertFalse(classDetailScreen.howManyChildrenLabel.exists)
            XCTAssertFalse(classDetailScreen.childCareIcon.exists)
            XCTAssertFalse(classDetailScreen.removeChildButton.exists)
            XCTAssertFalse(classDetailScreen.numberOfChildrenlabel.exists)
            XCTAssertFalse(classDetailScreen.addChildButton.exists)
        }
    }
    
    private func verifyReservationSuccessUI() {
        XCTAssertNotNil(reservationSuccessScreen.successIcon.exists)
        XCTAssertNotNil(reservationSuccessScreen.successTitle.exists)
        XCTAssertNotNil(reservationSuccessScreen.successMessage.exists)
        XCTAssertNotNil(reservationSuccessScreen.closeButton.exists)
    }
    
    private func verifyCancelClassDialogueAndContiue() {
        XCTAssertEqual(alert.title.label, "Sorry you can't make it")
        XCTAssertEqual(alert.message.label, "This is a required class, but if you are sure you can't make it, continue with your cancellation.")
        XCTAssertFalse(alert.buttonOne.exists)
        XCTAssertTrue(alert.buttonTwo.exists)
        XCTAssertTrue(alert.buttonThree.exists)
        XCTAssertEqual(alert.buttonTwo.label, "DISMISS")
        XCTAssertEqual(alert.buttonThree.label, "CONTINUE")
        
        alert.buttonThree.tap()
    }
    
    private func verifyDiscardChangesDialogue() {
        XCTAssertFalse(alert.title.exists)
        XCTAssertEqual(alert.message.label, "Oops, your edits didn't get saved. Do you want to keep working?")
        XCTAssertFalse(alert.buttonOne.exists)
        XCTAssertTrue(alert.buttonTwo.exists)
        XCTAssertTrue(alert.buttonThree.exists)
        XCTAssertEqual(alert.buttonTwo.label, "KEEP WORKING")
        XCTAssertEqual(alert.buttonThree.label, "DISCARD")
    }
        
    private func verifyClassListUI(hasReservation: Bool)  {
        XCTAssertTrue(classScreen.titleLabel.exists)
        XCTAssertTrue(classScreen.logoutButton.exists)
        XCTAssertTrue(classScreen.nextClassTitle.exists)
        XCTAssertTrue(classScreen.upcomingClassTitle.exists)
        
        // to do can we improve this
        if hasReservation {
            XCTAssertTrue(classScreen.nextClassIsReservedLabel.exists)
            XCTAssertFalse(classScreen.upcomingClassIsReservedLabl.exists)
            XCTAssertFalse(classScreen.nextClassButton.exists)
            XCTAssertFalse(classScreen.upcomingClassButton.exists)
        } else {
            waitForElementToAppear(classScreen.nextClassButton)
            XCTAssertTrue(classScreen.nextClassButton.exists)
            XCTAssertFalse(classScreen.upcomingClassButton.exists)
            XCTAssertFalse(classScreen.nextClassIsReservedLabel.exists)
            XCTAssertFalse(classScreen.upcomingClassIsReservedLabl.exists)
        }
    }
}
