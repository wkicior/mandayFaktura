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
    
    func testIsSpecial_returns_false_for_0_percent() {
        let vatRate = VatRate(value: 0)
        XCTAssertFalse(vatRate.special)
    }
    
    func testIsSpecial_returns_true_for_special_value() {
        let vatRate = VatRate(value: 0, literal: "zw.")
        XCTAssertTrue(vatRate.special)
    }
    
    func testVatRate_initsFromString_specialValue() {
        let vatRate = VatRate(string: "foo")
        XCTAssertEqual("foo", vatRate.literal)
        XCTAssertEqual(0, vatRate.value)
    }
    
    func testVatRate_initsFromString_0percent() {
        let vatRate = VatRate(string: "0%")
        XCTAssertEqual("0%", vatRate.literal)
        XCTAssertEqual(0, vatRate.value)
    }
    
    func testVatRate_initsFromString_10() {
        let vatRate = VatRate(string: "10")
        XCTAssertEqual("10", vatRate.literal)
        XCTAssertEqual(0, vatRate.value)
    }
    
    func testVatRate_initsFromString_30percent() {
        let vatRate = VatRate(string: "30%")
        XCTAssertEqual("30%", vatRate.literal)
        XCTAssertEqual(Decimal(string: "0.3"), vatRate.value)
    }
    
    func testVatRate_initsFromString_30percent_not_trimmed() {
        let vatRate = VatRate(string: " 30%" )
        XCTAssertEqual("30%", vatRate.literal)
        XCTAssertEqual(Decimal(string: "0.3"), vatRate.value)
    }
    
    func testVatRate_initsFromString_30percentfoobar() {
        let vatRate = VatRate(string: "30%foobar")
        XCTAssertEqual("30%foobar", vatRate.literal)
        XCTAssertEqual(Decimal(string: "0"), vatRate.value)
    }
    
    func testVatRate_hashValueSame() {
        let vatRate1 = VatRate(value: 0, literal: "0%", isDefault: false)
        let vatRate2 = VatRate(value: 0, literal: "0%", isDefault: false)
        XCTAssertEqual(vatRate1.hashValue, vatRate2.hashValue)
    }
    
    func testVatRate_hashValueDifferent() {
        let vatRate1 = VatRate(value: 0, literal: "0", isDefault: false)
        let vatRate2 = VatRate(value: 0, literal: "0%", isDefault: false)
        XCTAssertNotEqual(vatRate1.hashValue, vatRate2.hashValue)
    }
    
    func testVatRate_isDefaultIsIgnoredOnHashable() {
        let vatRate1 = VatRate(value: 0, literal: "0%", isDefault: false)
        let vatRate2 = VatRate(value: 0, literal: "0%", isDefault: true)
        XCTAssertEqual(vatRate1.hashValue, vatRate2.hashValue)
    }
}
