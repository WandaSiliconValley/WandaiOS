//
//  WandaDataManager.swift
//  Wanda
//
//  Created by Bell, Courtney on 6/21/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import Foundation

public enum FirebaseError: String {
    case invalidEmail = "invalid_email"
    case missingEmail = "missing_email"
    case wrongPassword = "wrong_password"
    case userNotFound = "user_not_found"
    case networkError = "network_error"
    case unknown
    
    init(errorCode: Int) {
        switch errorCode {
            case 17020:
                self = .networkError
            case 17008:
                self = .invalidEmail
            case 17034:
                self = .missingEmail
            case 17009:
                self = .wrongPassword
            case 17011:
                self = .userNotFound
            default:
                self = .unknown
        }
    }
}

class WandaDataManager {
    static let shared = WandaDataManager()
    
    var needsReload = false
    var wandaMother: WandaMotherInfo?
    var upcomingClasses = [WandaClass]()
    private var allClasses = [WandaClass]()
    var nextClass: WandaClass?
    
    init() { }
    
  //  func isIn
    
//    func isEven(number: Int) -> Bool {
//        return number % 2 == 0
//    }
//
//    evens = Array(1...10).filter(isEven)
//    println(evens)
    
    // to do dont like this!
    func removeReservation(_ wandaClass: WandaClass) {
        let classToUpdate = allClasses.filter { $0.details.classId == wandaClass.details.classId }.first
       classToUpdate?.isReserved = false
       classToUpdate?.childCareNumber = 0
    }
    
    func loadClasses() {
        
        // Check if any classes are reserved.
        if let reservedClassId = wandaMother?.reservedClassIds.first {
            allClasses.filter {$0.details.classId == reservedClassId}.first?.isReserved = true
        }
        
        var sortedClasses = allClasses.sortedByDate(descending: false)
        
        sortedClasses = sortedClasses.filter {DateFormatter.simpleDateFormatter.date(from: $0.details.date) ?? Date() >= Date()}
        
        //let pets = animals.filter { $0 != "chimps" }

       // sortedClasses.filter($0.d)
        
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
    
    func getWandaClasses(completion: @escaping (Bool, WandaError?) -> Void) {
        WandaClassesNetworkController.requestWandaClasses { wandaClasses, error in
            guard let wandaClasses = wandaClasses else {
                completion(false, error)
                return
            }
            
            self.allClasses = wandaClasses
            self.loadClasses()
            completion(true, nil)
        }
    }
    
    func getWandaMother(firebaseId: String, completion: @escaping (Bool, WandaError?) -> Void) {
        WandaMotherNetworkController.getWandaMother(firebaseId: firebaseId) { wandaMother, error in
            guard let wandaMother = wandaMother else {
                completion(false, error)
                return
            }
            
            self.wandaMother = WandaMotherInfo(from: wandaMother)
            completion(true, nil)
        }
    }
    
    func createWandaAccount(firebaseId: String, email: String, completion: @escaping (Bool, WandaError?) -> Void) {
        AccountNetworkController.createWandaAccount(firebaseId: firebaseId, email: email) { wandaMother, error in
            guard let wandaMother = wandaMother else {
                completion(false, error)
                return
            }
            
            self.wandaMother = WandaMotherInfo(from: wandaMother)
            completion(true, nil)
        }
    }
    
    func getReservedWandaClass(classId: Int, motherId: Int, completion: @escaping (Bool, ReservedWandaClass?, WandaError?) -> Void) {
        WandaClassesNetworkController.getReservedWandaClass(motherId: motherId, classId: classId) { reservedClass, error in
            guard let reservedClass = reservedClass else {
                completion(false, nil, error)
                return
            }
            
            completion(true, reservedClass, nil)
        }
    }
    
    func reserveWandaClass(classId: Int, motherId: Int, childcareNumber: Int, completion: @escaping (Bool, WandaError?) -> Void) {
        ClassRSVPNetworkController.reserveWandaClass(classId: classId, motherId: motherId, childcareNumber: childcareNumber) { success, error in
            guard success else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
    
    func cancelWandaClassReservation(classId: Int, motherId: Int, completion: @escaping (Bool, WandaError?) -> Void) {
        ClassRSVPNetworkController.cancelWandaClassReservation(classId: classId, motherId: motherId) { success, error in
            guard success else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
}
