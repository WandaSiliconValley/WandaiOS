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
    let motherId: Int
    let cohortId: Int
    let firebaseId: String
    let name: String
    let email: String
    let reservedClassIds: [Int]
//    let classesAttended: [String]
//    let classesMissed: [String]

    enum CodingKeys : String, CodingKey {
        case motherId
        case cohortId
        case firebaseId
        case name
        case email
        case reservedClassIds = "rsvps"
//        case classesAttended
//        case classesMissed
    }
}

struct WandaMotherInfo: CustomDebugStringConvertible {
    let motherId: Int
    let cohortId: Int
    let firebaseId: String
    let name: String
    let email: String
    let reservedClassIds: [Int]

    init(from wandaMother: WandaMother) {
        motherId = wandaMother.motherId
        cohortId = wandaMother.cohortId
        firebaseId = wandaMother.firebaseId
        name = wandaMother.name
        email = wandaMother.email
        reservedClassIds = wandaMother.reservedClassIds
    }

    var debugDescription: String {
        return "motherId: '\(motherId)', cohortId: '\(cohortId)' firebaseId: '\(firebaseId)', name: '\(name)', email: '\(email)', reservedClassIds: '\(reservedClassIds)'"
    }
}

//struct ReservedWandaClass: Decodable {
//    let childcareNumber: Int
//    let wandaClass: WandaClass
//
//    enum CodingKeys : String, CodingKey {
//        case childcareNumber
//        case wandaClass = "class"
//    }
//}
