//
//  WandaClassesNetworkController.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/12/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation

class WandaClassesNetworkController {
    static func requestWandaClasses(resultHandler: @escaping ([WandaClass]?, Error?) -> Void) {
        let endpoint: String = "\(WandaConstants.wandaURL)/classes"
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
                        print("Error: did not receive data")
                        return
                    }

                    do {
                        let wandaClasses = try JSONDecoder().decode(Array<WandaClass>.self, from: responseData)
                        let classes = wandaClasses.map { $0 }
                        resultHandler(classes, nil)
                    } catch  {
                        resultHandler(nil, error)
                    }
                }
            }
            task.resume()
        }
    }
}
