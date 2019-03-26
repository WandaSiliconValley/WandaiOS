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

struct WandaClass: Decodable {
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
    let childcareNumber: Int
   // let wandaClass: WandaClass = WandaClass(classId: 0, cohortId: 0, topic: "", speaker: "", description: "", date: "", time: "", address: "", unit: "", street: "", city: "")


//    required init(from decoder: Decoder) throws {
//        try decodeContainer(from: decoder)
//    }

//    enum CodingKeys: String, CodingKey {
//        case childcareNumber
//        case wandaClass = "class"
//    }

//    let tracker = try trackersContainer.nestedContainer(keyedBy: TrackerCodingKeys.self)
//    let newTracker = try trackerDecoder(container: tracker, trackerType: .overview)
//    trackers.append(newTracker)

//    func decodeContainer(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let testThis = try container.decode(Int.self, forKey: .childcareNumber)
//        let childCare = try container.nestedUnkeyedContainer(forKey: .childcareNumber)
////        let trackerDetails = try trackers.nestedContainer(keyedBy: SourceCodingKeys.self)
////        trackerInfo.name = try trackerDetails.decode(String.self, forKey: .trackerName)
//    }
}
//
//
//struct WandaMother: Decodable {
//    let motherId: Int
//    let firebaseId: String
//    let name: String
//    let email: String
//    let reservedClassIds: [Int]
//    //    let classesAttended: [String]
//    //    let classesMissed: [String]
//
//    enum CodingKeys : String, CodingKey {
//        case motherId
//        case firebaseId
//        case name
//        case email
//        case reservedClassIds = "rsvps"
//        //        case classesAttended
//        //        case classesMissed
//    }
//}


// to do maybe switch these two names or could do wandaclassdetail
class WandaClassInfo: CustomDebugStringConvertible {
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
    var isReserved: Bool
    var childCareNumber: Int

    // to do way too much duplication!!
    init(from wandaClass: WandaClass, isReserved: Bool) {
        classId = wandaClass.classId
        cohortId = wandaClass.cohortId
        topic = wandaClass.topic
        speaker = wandaClass.speaker
        description = wandaClass.description

        date = wandaClass.date
        time = wandaClass.time
        address = wandaClass.address
        unit = wandaClass.unit
        street = wandaClass.street
        city = wandaClass.city
        // is this right? at the point we map them we don't know what is reserved so this
        // is always false
        self.isReserved = isReserved
        childCareNumber = 0
    }

    var debugDescription: String {
        return ""
      //  return "name: '\(name)', totalAmountTracked: '\(totalAmountTracked)', trackerType: '\(trackerType)'"
    }
}
