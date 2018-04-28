//
//  VatRateTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 26.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

import XCTest
@testable import mandayFaktura

class VatRateTests: XCTestCase {
    func testVatRate_init_literal_23() {
        let vatRate = VatRate(value: Decimal(string: "0.23")!)
        XCTAssertEqual("23%", vatRate.literal)
    }
    
    func testVatRate_init_literal_0() {
        let vatRate = VatRate(value: 0)
        XCTAssertEqual("0%", vatRate.literal)
    }
}
