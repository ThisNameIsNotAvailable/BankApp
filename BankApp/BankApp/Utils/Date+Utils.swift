//
//  Date+Utils.swift
//  BankApp
//
//  Created by Alex on 15/12/2022.
//

import Foundation

extension Date {
    static var bankeyFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "MDT")
        return formatter
    }
    
    var monthDayYearString: String {
        let formatter = Date.bankeyFormatter
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
}
