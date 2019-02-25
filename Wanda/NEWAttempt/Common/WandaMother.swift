//
//  WandaMother.swift
//  Wanda
//
//  Created by Bell, Courtney on 1/5/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation

// should this be a singlton?? there should only ever be one mother
// hwoever we will have to re-get the mom if the make a reservation
struct WandaMother: Decodable {
    let motherId: String
    let firebaseId: String
    let name: String
    let email: String
    let reservedClasses: [ReservedWandaClass]

    enum CodingKeys : String, CodingKey {
        case motherId
        case firebaseId
        case name
        case email
        case reservedClasses = "rsvps"
    }
}

struct WandaMotherInfo: CustomDebugStringConvertible {
    let motherId: String
    let firebaseId: String
    let name: String
    let email: String
    let reservedClasses: [WandaClassInfo]

    init(from wandaMother: WandaMother) {
        motherId = wandaMother.motherId
        firebaseId = wandaMother.firebaseId
        name = wandaMother.name
        email = wandaMother.email
        reservedClasses = wandaMother.reservedClasses.map { WandaClassInfo(from: $0) }
    }

    var debugDescription: String {
        return "motherId: '\(motherId)', firebaseId: '\(firebaseId)', name: '\(name)', email: '\(email)', reservedClasses: '\(reservedClasses)'"
    }
}

struct ReservedWandaClass: Decodable {
    let childcareNumber: Int
    let wandaClass: WandaClass

    enum CodingKeys : String, CodingKey {
        case childcareNumber
        case wandaClass = "class"
    }
}
