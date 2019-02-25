//
//  ClassRSVPNetworkController.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/12/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation

class ClassRSVPNetworkController {
    static func reserveWandaClass(classId: String, motherId: String, childcareNumber: Int, resultHandler: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "\(WandaConstants.wandaURL)/rsvp")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["classId": classId, "motherId": motherId, "childcareNumber": childcareNumber]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard data != nil else {
                        print("Error: did not receive data")
                        resultHandler(false, error)
                        return
                    }
                    resultHandler(true, nil)
                }
            }
            task.resume()
        }
    }

    static func cancelWandaClassReservation(classId: String, motherId: String, resultHandler: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "\(WandaConstants.wandaURL)/rsvp/\(classId)/\(motherId)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"

        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard data != nil else {
                        print("Error: did not receive data")
                        resultHandler(false, error)
                        return
                    }
                    resultHandler(true, nil)
                }
            }
            task.resume()
        }
    }
}
