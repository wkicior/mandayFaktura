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
    
    func testIndexFirst() {
        let currency = Currency.AED
        XCTAssertEqual(0, currency.index, "Currency index must match")
    }
    
    func testIndexPln() {
        let currency = Currency.PLN
        XCTAssertEqual(112, currency.index, "Currency index must match")
    }
    
    func testOfIndexFirst() {
        let currency = Currency.ofIndex(0)
        XCTAssertEqual(Currency.AED, currency, "Currency index must match")
    }
    
    func testOfIndexPln() {
        let currency = Currency.ofIndex(112)
        XCTAssertEqual(Currency.PLN, currency, "Currency index must match")
    }
    
    func testPlnCents() {
        let currency = Currency.PLN
        XCTAssertEqual("gr", currency.centsKey, "Currency cents key must match")
    }
    
    func testEurCents() {
        let currency = Currency.EUR
        XCTAssertEqual("c", currency.centsKey, "Currency cents key must match")
    }
    
    func testUnknownCents() {
        let currency = Currency.AED
        XCTAssertNil(currency.centsKey, "Currency cents is unknown")
    }
}
