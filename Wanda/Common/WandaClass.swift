//
//  WandaClass.swift
//  Wanda
//
//  Created by Bell, Courtney on 3/4/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import Foundation

enum ClassType {
    case nextClass
    case upcomingClass
}

struct WandaClassDetail: Decodable {
    let classId: Int
    let cohortId: Int
    let topic: String
    let speaker: String
    let description: String
    let date: String
    let time: String
    let address: String
    let unit: String
    let street: String
    let city: String
}

class ReservedWandaClass: Decodable {
    let rsvpId: Int
    let childcareNumber: Int
}

class WandaClass: CustomDebugStringConvertible {
    let details: WandaClassDetail
    var isReserved: Bool
    var childCareNumber: Int
    var rsvpId: Int

    init(from wandaClassDetail: WandaClassDetail, isReserved: Bool) {
        self.details = wandaClassDetail
        self.isReserved = isReserved
        childCareNumber = 0
        rsvpId = 0
    }

    var debugDescription: String {
        return "details '\(details)', isReserved: '\(isReserved)', childCareNumber: '\(childCareNumber)'"
    }
}
