//
//  DateFormatter+Wanda.swift
//  Wanda
//
//  Created by Courtney & Matt on 4/11/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation

extension DateFormatter {

    static var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH':'mm':'ss'.'SSS"
        return formatter
    }()

    // Ex: Saturday, March 25th
    static var fullDayMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "cccc, MMMM dd"
        return formatter
    }()

    // Ex: 2019 - 01 - 03
    static var simpleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd"
        return formatter
    }()

    static var dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS"
        return formatter
    }()
    
    // Ex: Apr
    static var shortMonthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()
    
    // Ex: 2:30AM 
    static var timeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"
        return formatter
    }()
}
