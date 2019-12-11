//
//  ClassDetailScreen.swift
//  WandaUITests
//
//  Created by Courtney on 12/5/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import XCTest

class ClassDetailScreen: Screen {
    // to do how do we feel about this - you can pull the label from its name in the storyboard
    // this could chang but so could an accessibility labl so i think this is just as good
    var dateLabel: XCUIElement {
        return app.staticTexts["date_label"]
    }

    var timeLabel: XCUIElement {
        return app.staticTexts["time_label"]
    }

    var locationNameLabel: XCUIElement {
        return app.staticTexts["location_name_label"]
    }
    
    var addressLabel: XCUIElement {
        return app.staticTexts["address_label"]
    }

    var childCareLabel: XCUIElement {
        return app.staticTexts["child_care_label"]
    }

    var howManyChildrenLabel: XCUIElement {
        return app.staticTexts["how_many_children_label"]
    }

    var numberOfChildrenlabel: XCUIElement {
        return app.staticTexts["number_of_children"]
    }

    var removeChildButton: XCUIElement {
        return app.buttons["remove_child_button"]
    }

    var addChildButton: XCUIElement {
        return app.buttons["add_child_button"]
    }

    var reserveMySpotButton: XCUIElement {
        return app.buttons["RESERVE MY SPOT"]
    }
    
    var dateTimeIcon: XCUIElement {
        return app.images["date_icon"]
    }

    var locationIcon: XCUIElement {
        return app.images["location_icon"]
    }

    var childCareIcon: XCUIElement {
        return app.images["child_care_icon"]
    }

    var changeRSVPButton: XCUIElement {
        return app.buttons["CHANGE RSVP"]
    }
    
    var updateRSVPButton: XCUIElement {
        return app.buttons["UPDATE RSVP"]
    }
    
    var cancelReservationButton: XCUIElement {
        return app.buttons["CANCEL RESERVATION"]
    }
    
    var reservedIcon: XCUIElement {
        return app.images["reserved_icon"]
    }
    
    var spotIsReservedLabel: XCUIElement {
        return app.staticTexts["Your spot has been reserved"]
    }
    
    var reservedOverlayView: XCUIElement {
        return app.otherElements["overlay_view"]
    }
    
    var overflowMenu: XCUIElement {
        return app.navigationBars.buttons["OverflowIcon"]
    }
    
    var contactUsButton: XCUIElement {
        return app.buttons["contact_us_button"]
    }
    
    var addToCalendarButton: XCUIElement {
        return app.buttons["add_to_calendar_button"]
    }
}


