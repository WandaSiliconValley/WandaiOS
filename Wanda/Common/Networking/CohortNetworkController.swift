//
//  CohortNetworkController.swift
//  Wanda
//
//  Created by Courtney Bell on 2/22/21.
//  Copyright © 2021 Bell, Courtney. All rights reserved.
//

import Foundation

class CohortNetworkController {
    static func getCohort(cohortId: Int, resultHandler: @escaping(Cohort?, WandaError?) -> Void) {
        let url = URL(string: "\(WandaDataManager.shared.environmentURL)/cohorts/\(cohortId)")!
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
                        let cohort = try JSONDecoder().decode(Cohort.self, from: responseData)
                        resultHandler(cohort, nil)
                    } catch {
                        resultHandler(nil, WandaError(error.code))

                    }
                }
            }
            task.resume()
        }
    }
}
