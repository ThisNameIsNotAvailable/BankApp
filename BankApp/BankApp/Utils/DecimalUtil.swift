//
//  DecimalUtil.swift
//  BankApp
//
//  Created by Alex on 01/12/2022.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
