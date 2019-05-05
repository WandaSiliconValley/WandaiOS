//
//  AccountNetworkController.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/12/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation

class AccountNetworkController {
    static func createWandaAccount(firebaseId: String, email: String, resultHandler: @escaping(WandaMother?, WandaError?) -> Void) {
        let url = URL(string: "\(WandaConstants.wandaURL)/account")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["firebaseId": firebaseId, "email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let responseData = data else {
                        resultHandler(nil, WandaError.unknown)
                        return
                    }
                    
                    
                    print("DATA \(data)")
                    print("RESPONSE \(response)")
                    
                    do {
                        let wandaMother = try JSONDecoder().decode(WandaMother.self, from: responseData)
                        resultHandler(wandaMother, nil)
                    } catch  {
                        resultHandler(nil, WandaError(error.code))
                    }
                }
            }
            task.resume()
        }
    }
}
