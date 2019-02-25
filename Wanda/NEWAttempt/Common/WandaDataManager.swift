//
//  WandaDataManager.swift
//  Wanda
//
//  Created by Bell, Courtney on 6/21/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import Foundation

// can only sign up 7 days before

class WandaDataManager {
    static let shared = WandaDataManager()

    var wandaMother: WandaMotherInfo?
    var upcomingClasses = [WandaClassInfo]()
    var allClasses = [WandaClass]()
    var nextClass: WandaClassInfo?

    init() { }

    func loadClasses() {
        let newClasses = allClasses.map { WandaClassInfo(from: $0, isReserved: false) }
        // Check if any classes are reserved.
        if let reservedClass = wandaMother?.reservedClasses.first {
            newClasses.filter {$0.classId == reservedClass.classId}.first?.isReserved = true
        }

        var sortedClasses = newClasses.sortedByDate()
        if let nextClass = sortedClasses.first {
            self.nextClass = nextClass
        }

        // Remove first element (next class) and then set upcoming classes
        sortedClasses.removeFirst()
        self.upcomingClasses = sortedClasses
    }

    func numberOfSections() -> Int {
        if allClasses.isEmpty {
            return 0
        } else if allClasses.count == 1 {
            return 1
        }

        return 2
    }

    func getWandaClasses(completion: @escaping (Bool) -> Void) {
        WandaClassesNetworkController.requestWandaClasses { wandaClasses, error in
            guard let wandaClasses = wandaClasses else {
                completion(false)
                return
            }

            self.allClasses = wandaClasses
            self.loadClasses()
            completion(true)
        }
    }

    func getWandaMother(firebaseId: String, completion: @escaping (Bool) -> Void) {
        WandaMotherNetworkController.getWandaMother(firebaseId: firebaseId) { wandaMother, error in
            guard let wandaMother = wandaMother else {
                completion(false)
                return
            }

            self.wandaMother = WandaMotherInfo(from: wandaMother)
            completion(true)
        }
    }

    func createWandaAccount(firebaseId: String, email: String, completion: @escaping (Bool) -> Void) {
        AccountNetworkController.createWandaAccount(firebaseId: firebaseId, email: email) { wandaMother, error in
            guard let wandaMother = wandaMother else {
                completion(false)
                return
            }

            self.wandaMother = WandaMotherInfo(from: wandaMother)
            completion(true)
        }
    }

    func reserveWandaClass(classId: String, motherId: String, childcareNumber: Int, completion: @escaping (Bool) -> Void) {
        ClassRSVPNetworkController.reserveWandaClass(classId: classId, motherId: motherId, childcareNumber: childcareNumber) { success, error in
            guard success else {
                completion(false)
                return
            }

            completion(true)
        }
    }

    func cancelWandaClassReservation(classId: String, motherId: String, completion: @escaping (Bool) -> Void) {
        ClassRSVPNetworkController.cancelWandaClassReservation(classId: classId, motherId: motherId) { success, error in
            guard success else {
                completion(false)
                return
            }

            completion(true)
        }
    }
}
