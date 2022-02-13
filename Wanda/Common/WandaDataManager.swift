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
    
    var environmentURL = WandaConstants.wandaDevURL
    var needsReload = false
    var profilePictureNeedsReload = false
    var wandaMother: WandaMotherInfo?
    var upcomingClasses = [WandaClass]()
    private var allClasses = [WandaClass]()
    var nextClass: WandaClass?
    var hasCurrentClasses = true
    var cohortSections = [CohortSection]()
    var cohortMothers = [WandaCohortMother]()
    
    struct CohortSection {
        var cohortId: Int
        var mothers: [WandaCohortMother]
        var collapsed: Bool

        init(cohortId: Int, mothers: [WandaCohortMother], collapsed: Bool = false) {
            self.cohortId = cohortId
            self.mothers = mothers
            self.collapsed = collapsed
      }
    }

    
    private init() {
        #if DEBUG
            environmentURL = WandaConstants.wandaDevURL
        #endif
    }
    
    // to do dont like this!
    func removeReservation(_ wandaClass: WandaClass) {
        let classToUpdate = allClasses.filter { $0.details.classId == wandaClass.details.classId }.first
       classToUpdate?.isReserved = false
       classToUpdate?.childCareNumber = 0
    }
    
    func loadClasses() {
        
        // Check if any classes are reserved.
        if let reservedClasses = wandaMother?.reservedClassIds {
            for wandaClass in reservedClasses {
                allClasses.filter {$0.details.classId == wandaClass}.first?.isReserved = true
            }
        }

        var sortedClasses = allClasses.sortedByDate(descending: false)
        sortedClasses = sortedClasses.filter {(DateFormatter.simpleDateFormatter.date(from: $0.details.date) ?? Date() >= Date())}
        if let nextClass = sortedClasses.first {
            self.nextClass = nextClass
        }
        
        // Remove first element (next class) and then set upcoming classes
        if !sortedClasses.isEmpty {
            sortedClasses.removeFirst()
        } else {
            hasCurrentClasses = false
        }
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
    
    func getWandaMother(firebaseId: String, completion: @escaping (Bool, WandaError?, Int) -> Void) {
        WandaMotherNetworkController.getWandaMother(firebaseId: firebaseId) { wandaMother, error in
            guard let wandaMother = wandaMother else {
                completion(false, error, 0)
                return
            }
            
            let motherInfo = WandaMotherInfo(from: wandaMother)
            self.wandaMother = motherInfo
            completion(true, nil, motherInfo.cohortId)
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
    
    func cancelWandaClassReservation(rsvpId: Int, completion: @escaping (Bool, WandaError?) -> Void) {
        ClassRSVPNetworkController.cancelWandaClassReservation(rsvpId: rsvpId) { success, error in
            guard success else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
    
    func updateWandMother(mother: EditWandaMotherInfo, completion: @escaping (Bool, WandaError?) -> Void) {
        WandaMotherNetworkController.updateWandaMother(mother: mother) { wandaMother, error in
            guard let wandaMother = wandaMother else {
                completion(false, error)
                return
            }

            self.wandaMother = WandaMotherInfo(from: wandaMother)
            completion(true, nil)
        }
    }
    
    func getCohort(cohortId: Int, completion: @escaping (Bool, WandaError?) -> Void) {
        CohortNetworkController.getCohort(cohortId: cohortId) { cohort, error in
            guard let cohort = cohort else {
                completion(false, error)
                return
            }
            var updatedCohortMothers = [WandaCohortMother]()
            if let motherId = self.wandaMother?.motherId {
                for mother in cohort.mothers {
                    if mother.motherId != motherId {
                        updatedCohortMothers.append(mother)
                    }
                }
            } else {
                updatedCohortMothers = cohort.mothers
            }
            self.cohortMothers = updatedCohortMothers
            self.cohortSections = [CohortSection(cohortId: cohort.cohortId, mothers: updatedCohortMothers)]
            completion(true, nil)
        }
    }
    
    func uploadMotherPhoto(motherId: String, photo: String, completion: @escaping (Bool, WandaError?) -> Void) {
        PhotoNetworkController.uploadMotherPhoto(motherId: motherId, photo: photo) { success, error in
            guard let success = success else {
                completion(false, error)
                return
            }
            
//            self.cohortSections = [CohortSection(cohortId: cohort.cohortId, mothers: cohort.mothers)]
            completion(true, nil)
        }
    }
}
