//
//  WandaMotherNetworkController.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/12/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation

class WandaMotherNetworkController {
    static func getWandaMother(firebaseId: String, resultHandler: @escaping(WandaMother?, WandaError?) -> Void) {
        let url = URL(string: "\(WandaDataManager.shared.environmentURL)/mother/\(firebaseId)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let urlRequest = URLRequest(url: url)
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                DispatchQueue.main.async {
                    guard let responseData = data else {
                        resultHandler(nil, WandaError.unknown)
                        return
                    }

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

public enum WandaError {
    case networkError
    case unknown
    
    init(_ errorCode: Int) {
        switch errorCode {
            case -1009:
                self = .networkError
            default:
                self = .unknown
        }
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
