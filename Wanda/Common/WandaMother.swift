//
//  WandaMother.swift
//  Wanda
//
//  Created by Bell, Courtney on 1/5/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation

struct WandaMother: Decodable {
    let motherId: Int
    let firebaseId: String
    let name: String
    let email: String
    let reservedClassIds: [Int]
    enum CodingKeys : String, CodingKey {
        case motherId
        case firebaseId
        case name
        case email
        case reservedClassIds = "rsvps"
    }
}

struct WandaMotherInfo: CustomDebugStringConvertible {
    let motherId: Int
    let firebaseId: String
    let name: String
    let email: String
    let reservedClassIds: [Int]

    init(from wandaMother: WandaMother) {
        motherId = wandaMother.motherId
        firebaseId = wandaMother.firebaseId
        name = wandaMother.name
        email = wandaMother.email
        reservedClassIds = wandaMother.reservedClassIds
    }

    var debugDescription: String {
        return "motherId: '\(motherId)', firebaseId: '\(firebaseId)', name: '\(name)', email: '\(email)', reservedClassIds: '\(reservedClassIds)'"
    }
}
