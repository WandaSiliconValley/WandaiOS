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
    let cohortId: Int
    let contactEmail: String?
    let shareContactEmail: Bool
    let sharePhoneNumber: Bool
    let phoneNumber: String?
    let bio: String?
    let languages: [String]
    let reservedClassIds: [Int]
    enum CodingKeys : String, CodingKey {
        case motherId
        case firebaseId
        case name
        case email
        case cohortId
        case contactEmail
        case shareContactEmail
        case sharePhoneNumber
        case phoneNumber
        case bio
        case languages
        case reservedClassIds = "rsvps"
    }
}

struct WandaMotherInfo: CustomDebugStringConvertible {
    let motherId: Int
    let firebaseId: String
    let name: String
    let email: String
    let cohortId: Int
    let reservedClassIds: [Int]
    let contactEmail: String?
    let shareContactEmail: Bool
    let sharePhoneNumber: Bool
    var phoneNumber: String?
    let bio: String?
    let languages: [String]

    init(from wandaMother: WandaMother) {
        motherId = wandaMother.motherId
        firebaseId = wandaMother.firebaseId
        name = wandaMother.name
        email = wandaMother.email
        reservedClassIds = wandaMother.reservedClassIds
        cohortId = wandaMother.cohortId
//        contactEmail = wandaMother.contactEmail
        contactEmail = "bellcourtney@yahoo.com"
        shareContactEmail = wandaMother.shareContactEmail
        sharePhoneNumber = wandaMother.sharePhoneNumber
        phoneNumber = wandaMother.phoneNumber
        bio = wandaMother.bio
        languages = ["English", "Spanish"]
//        languages = wandaMother.languages
    }

    var debugDescription: String {
        return "motherId: '\(motherId)', firebaseId: '\(firebaseId)', name: '\(name)', email: '\(email)', reservedClassIds: '\(reservedClassIds)'"
    }
}

struct EditWandaMotherInfo: CustomDebugStringConvertible {
    let motherId: Int
    let firebaseId: String
    let cohortId: Int
    let name: String
    let email: String
    let contactEmail: String?
    let shareContactEmail: Bool
    let sharePhoneNumber: Bool
    var phoneNumber: String?
    let bio: String?
    let languages: [String]
    
    var debugDescription: String {
        return "motherId: '\(motherId)', firebaseId: '\(firebaseId)', name: '\(name)', contactEmail: '\(contactEmail)'"
    }
}
