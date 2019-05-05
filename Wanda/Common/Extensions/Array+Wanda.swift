//
//  ArrayExtension+Wanda.swift
//  Wanda
//
//  Created by Bell, Courtney on 6/28/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import Foundation

extension Array where Iterator.Element == WandaClass {
    func sortedByDate(descending shouldUseDescendingOrder: Bool = true) -> [WandaClass] {
        return sorted {
            let date = $0.details.date
            let secondDate = $1.details.date

//            if $0.details.date > Date() {
//                print("PAST \($0.details.date)")
//            }
            
            if shouldUseDescendingOrder {
                return date > secondDate
            }

            return date < secondDate
        }
    }
}
