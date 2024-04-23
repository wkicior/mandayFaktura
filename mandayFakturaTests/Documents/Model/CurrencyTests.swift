//
//  CurrencyTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 21/04/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura


class CurrencyTests: XCTestCase {
    func testToString() {
        let currency = Currency.PLN
        XCTAssertEqual("PLN", currency.rawValue, "Currency code must match")
    }
    
    func testFromString() {
        let currency = Currency(rawValue: "PLN")!
        XCTAssertEqual(Currency.PLN, currency, "Currency must match")
    }
}
