//
//  ArrayExtension+Wanda.swift
//  Wanda
//
//  Created by Bell, Courtney on 6/28/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import Foundation

internal extension Array where Iterator.Element == WandaClassInfo {
    func sortedByDate(descending shouldUseDescendingOrder: Bool = true) -> [WandaClassInfo] {
        return sorted {
            let date = $0.date
            let secondDate = $1.date

            if shouldUseDescendingOrder {
                return date > secondDate
            }

            return date < secondDate
        }
    }
}
