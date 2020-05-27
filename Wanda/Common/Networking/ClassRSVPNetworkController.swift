//
//  ClassRSVPNetworkController.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/12/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation

class ClassRSVPNetworkController {
    static func reserveWandaClass(classId: Int, motherId: Int, childcareNumber: Int, resultHandler: @escaping (Bool, WandaError?) -> Void) {
        let url = URL(string: "\(WandaDataManager.shared.environmentURL)/rsvp")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["classId": classId, "motherId": motherId, "childcareNumber": childcareNumber]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard data != nil else {
                        guard let error = error else {
                            resultHandler(false, WandaError.unknown)
                            return
                        }
                        
                        resultHandler(false, WandaError(error.code))
                        return
                    }
                    resultHandler(true, nil)
                }
            }
            task.resume()
        }
    }
    
    static func cancelWandaClassReservation(rsvpId: Int, resultHandler: @escaping (Bool, WandaError?) -> Void) {
        let url = URL(string: "\(WandaDataManager.shared.environmentURL)/rsvp/\(rsvpId)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard data != nil else {
                        guard let error = error else {
                            resultHandler(false, WandaError.unknown)
                            return
                        }
                        
                        resultHandler(false, WandaError(error.code))
                        return
                    }
                    resultHandler(true, nil)
                }
            }
            task.resume()
        }
    }
}
