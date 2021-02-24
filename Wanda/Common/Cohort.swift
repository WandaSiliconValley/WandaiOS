//
//  Cohort.swift
//  Wanda
//
//  Created by Courtney Bell on 2/22/21.
//  Copyright © 2021 Bell, Courtney. All rights reserved.
//

import Foundation

struct Cohort: Decodable {
    let cohortId: Int
    let mothers: [WandaCohortMother]
    enum CodingKeys : String, CodingKey {
        case cohortId
        case mothers
    }
}


struct WandaCohortMother: Decodable {
    let motherId: Int
    let firebaseId: String?
    let name: String
    let email: String
    let cohortId: Int?
    let contactEmail: String?
    let shareContactEmail: Bool?
    let sharePhoneNumber: Bool?
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
