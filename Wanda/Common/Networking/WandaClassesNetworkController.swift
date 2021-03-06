//
//  WandaClassesNetworkController.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/12/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation

class WandaClassesNetworkController {
    static func getReservedWandaClass(motherId: Int, classId: Int, resultHandler: @escaping (ReservedWandaClass?, WandaError?) -> Void) {
        let endpoint = "\(WandaDataManager.shared.environmentURL)/rsvp/\(classId)/\(motherId)"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let responseData = data else {
                        resultHandler(nil, WandaError.unknown)
                        return
                    }
                    
                    do {
                        let reservedWandaClass = try JSONDecoder().decode(ReservedWandaClass.self, from: responseData)
                        resultHandler(reservedWandaClass, nil)
                    } catch  {
                        resultHandler(nil, WandaError(error.code))
                    }
                }
            }
            task.resume()
        }
    }
    
    static func requestWandaClasses(resultHandler: @escaping ([WandaClass]?, WandaError?) -> Void) {
        let endpoint: String = "\(WandaDataManager.shared.environmentURL)/classes"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let responseData = data else {
                        resultHandler(nil, WandaError.unknown)
                        return
                    }
                    
                    do {
                        let wandaClasses = try JSONDecoder().decode(Array<WandaClassDetail>.self, from: responseData)
                        // We always set isReserved to false because we don't know what it is yet.
                        // When we get the Wanda Mother we set the real value of isReserved.
                        let classes = wandaClasses.map { WandaClass(from: $0, isReserved: false) }
                        resultHandler(classes, nil)
                    } catch  {
                        resultHandler(nil, WandaError(error.code))
                    }
                }
            }
            task.resume()
        }
    }
}
