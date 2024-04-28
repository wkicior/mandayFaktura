//
//  DecimalPrintingExtensionsTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 27/04/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura

class DecimalPrintingExtensionsTests: XCTestCase {
    
    func testSpelledOutPlWithFraction() {
        let decimal = Decimal(string: "123.45")
        XCTAssertEqual("sto dwadzieścia trzy PLN czterdzieści pięć gr", decimal?.spelledOutCurrency(language: .PL, currency: .PLN))
    }
    
    func testSpelledOutPlNoFraction() {
        let decimal = Decimal(string: "123")
        XCTAssertEqual("sto dwadzieścia trzy PLN zero gr", decimal?.spelledOutCurrency(language: .PL, currency: .PLN))
    }
    
    func testSpelledOutEnWithFraction() {
        let decimal = Decimal(string: "123.45")
        XCTAssertEqual("one hundred twenty-three PLN forty-five gr", decimal?.spelledOutCurrency(language: .EN, currency: .PLN))
    }
    
    func testSpelledOutEnNoFraction() {
        let decimal = Decimal(string: "123")
        XCTAssertEqual("one hundred twenty-three PLN zero gr", decimal?.spelledOutCurrency(language: .EN, currency: .PLN))
    }
    
    func testSpelledOutEnNoFractionUnknownCents() {
        let decimal = Decimal(string: "123")
        XCTAssertEqual("one hundred twenty-three AED", decimal?.spelledOutCurrency(language: .EN, currency: .AED))
    }
    
    func testSpelledOutPlWithFractionUnknownCents() {
        let decimal = Decimal(string: "123.45")
        XCTAssertEqual("sto dwadzieścia trzy AED czterdzieści pięć AED/100", decimal?.spelledOutCurrency(language: .PL, currency: .AED))
    }
    
    func testSpelledOutEnWithFractionUnknownCents() {
        let decimal = Decimal(string: "123.45")
        XCTAssertEqual("one hundred twenty-three AED forty-five AED/100", decimal?.spelledOutCurrency(language: .EN, currency: .AED))
    }
}
    
