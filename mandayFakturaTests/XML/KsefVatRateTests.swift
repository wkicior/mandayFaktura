//
//  KsefVatRateTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 03/02/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura


class KsefVatRateTests: XCTestCase {
    
    func testGetKsefCode_Numeric() {
        XCTAssertEqual("23", try! VatRate(string: "23%").toKsefCode(), "Ksef vat rate code must match")
        XCTAssertEqual("0", try! VatRate(string: "0%").toKsefCode(), "Ksef vat rate code must match")
        XCTAssertEqual("8", try! VatRate(string: "8").toKsefCode(), "Ksef vat rate code must match")
    }
    
    func testGetKsefCode_Special() {
        XCTAssertEqual("np", try! VatRate(string: "NP").toKsefCode(), "Ksef vat rate code must match")
        XCTAssertEqual("zw", try! VatRate(string: "Zw").toKsefCode(), "Ksef vat rate code must match")
        XCTAssertEqual("oo", try! VatRate(string: "OO").toKsefCode(), "Ksef vat rate code must match")
    }
    
    func testGetKsefCode_NotSupported() {
        XCTAssertThrowsError(try VatRate(string: "NPX").toKsefCode())
        XCTAssertThrowsError(try VatRate(string: "").toKsefCode())

    }
}

