//
//  CounterpartyTests.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 06/01/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura


class CounterpartyTests: XCTestCase {
    
    func testNipFromVatPL() {
        let counterparty = aCounterparty().withTaxCode("PL123456789").build()
        XCTAssertEqual("123456789", counterparty.nip, "NIP must match")
    }
    
    func testNip() {
        let counterparty = aCounterparty().withTaxCode("123456789").build()
        XCTAssertEqual("123456789", counterparty.nip, "NIP must match")
    }
    
    func testCountryAssumingPolandForDefinedCountry() {
        let counterparty = aCounterparty().withCountry("Denmark").build()
        XCTAssertEqual("Denmark", counterparty.countryOrAssumePoland)
    }
    
    func testCountryAssumingPolandForNoCountry() {
        let counterparty = aCounterparty().build()
        XCTAssertEqual("Polska", counterparty.countryOrAssumePoland)
    }
    
    func testCountryAssumingPolandForEmptyCountry() {
        let counterparty = aCounterparty().withCountry(" ").build()
        XCTAssertEqual("Polska", counterparty.countryOrAssumePoland)
    }
    
    func testCountryAssumingPolandForPoland() {
        let counterparty = aCounterparty().withCountry("Polska").build()
        XCTAssertEqual("Polska", counterparty.countryOrAssumePoland)
    }
}
