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
    let classId: String
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

// to do maybe switch these two names or could do wandaclassdetail
class WandaClassInfo: CustomDebugStringConvertible {
    let classId: String
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

    init(from reservedWandaClass: ReservedWandaClass) {
        classId = reservedWandaClass.wandaClass.classId
        cohortId = reservedWandaClass.wandaClass.cohortId
        topic = reservedWandaClass.wandaClass.topic
        speaker = reservedWandaClass.wandaClass.speaker
        description = reservedWandaClass.wandaClass.description
        date = reservedWandaClass.wandaClass.date
        time = reservedWandaClass.wandaClass.time
        address = reservedWandaClass.wandaClass.address
        unit = reservedWandaClass.wandaClass.unit
        street = reservedWandaClass.wandaClass.street
        city = reservedWandaClass.wandaClass.city
        // is this right? at the point we map them we don't know what is reserved so this
        // is always false
        self.isReserved = true
        childCareNumber = reservedWandaClass.childcareNumber
    }

    var debugDescription: String {
        return ""
      //  return "name: '\(name)', totalAmountTracked: '\(totalAmountTracked)', trackerType: '\(trackerType)'"
    }
}




//"classId": "1",
//"cohortId": 10,
//"topic": "Financial Literacy I",
//"speaker": "Corinne Augustine, Technology Credit Union",
//"description": "Intro to WANDA, debt, budgeting, account opening",
//"date": "2017-03-25",
//"time": "9:30AM - 2:00PM",
//"address": "Delaware Pacific Apts.",
//"unit": "",
//"street": "1990 S. Delaware Street",
//"city": "San Mateo"

//public struct ClassInfo {
//    var name: String
//    var startDateTime: Date
//    var endDateTime: Date
//    var type: ClassType
//    var location: String
//    var nextClass: WandaClass?
//    var upcomingClasses = [WandaClass]()
//
//    init(name: String, type: ClassType, startDateTime: Date, endDateTime: Date, location: String) {
//        self.name = name
//        self.type = type
//        self.startDateTime = startDateTime
//        self.endDateTime = endDateTime
//        self.location = location
//
////        switch type {
////            case .nextClass:
////                nextClass = wandaClass
////            case .upcomingClass:
////                upcomingClasses.append(wandaClass)
////        }
//    }
//
//    // MARK: CustomDebugStringConvertible
//    var debugDescription: String {
//        return "classname: '\(name)', classType: '\(type)', startDateTime: '\(startDateTime)', endDateTime: '\(endDateTime)', location: '\(location)'"
//    }
//}

