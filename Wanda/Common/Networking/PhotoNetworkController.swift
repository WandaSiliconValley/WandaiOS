//
//  PhotoNetworkController.swift
//  Wanda
//
//  Created by Courtney Bell on 2/24/21.
//  Copyright © 2021 Bell, Courtney. All rights reserved.
//

import Foundation

class PhotoNetworkController {
    static func uploadMotherPhoto(motherId: String, photo: String, resultHandler: @escaping(Bool?, WandaError?) -> Void) {
        let url = URL(string: "\(WandaDataManager.shared.environmentURL)/mother/photo")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "motherId": motherId, "photo": photo
        ]
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
    
}
