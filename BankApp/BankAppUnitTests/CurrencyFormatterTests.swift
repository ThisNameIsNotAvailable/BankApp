//
//  CurrencyFormatterTests.swift
//  BankAppUnitTests
//
//  Created by Alex on 14/12/2022.
//

import Foundation

import XCTest

@testable import BankApp

class Test: XCTestCase {
    
    var formatter: CurrencyFormatter!
    
    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }
    
    func testBreakIntoDollarsAndCents() throws {
        let result = formatter.breakIntoDollarsAndCents(826656.32)
        XCTAssertEqual(result.0, "826,656")
        XCTAssertEqual(result.1, "32")
    }
    
    func testDollarsFormatter() throws {
        XCTAssertEqual("$15,345.00", formatter.dollarsFormatted(15345))
    }
    
    func testZeroDollarsFormatter() throws {
        XCTAssertEqual("$0.00", formatter.dollarsFormatted(0.0))
    }
}
