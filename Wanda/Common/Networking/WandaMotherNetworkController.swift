//
//  WandaMotherNetworkController.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/12/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation

class WandaMotherNetworkController {
    static func getWandaMother(firebaseId: String, resultHandler: @escaping(WandaMother?, Error?) -> Void) {
        let url = URL(string: "\(WandaConstants.wandaURL)/mother/\(firebaseId)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let urlRequest = URLRequest(url: url)

        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            // to do why is error always nil here???
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                DispatchQueue.main.async {

                    // look at response.errorbody
                    // response.message
                    guard let responseData = data, let wandaMother = try? JSONDecoder().decode(WandaMother.self, from: responseData) else {
                        resultHandler(nil, error)
                        return
                    }
                    resultHandler(wandaMother, nil)
                }
            }
            task.resume()
        }
    }
}
