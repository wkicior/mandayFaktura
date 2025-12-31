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
        XCTAssertEqual("8", try! VatRate(string: "8").toKsefCode(), "Ksef vat rate code must match")
    }
    
    func testGetKsefCode_Special() {
        XCTAssertEqual("np I", try! VatRate(string: "np I").toKsefCode(), "Ksef vat rate code must match")
        XCTAssertEqual("np II", try! VatRate(string: "np II").toKsefCode(), "Ksef vat rate code must match")
        XCTAssertEqual("0 EX", try! VatRate(string: "0 EX").toKsefCode(), "Ksef vat rate code must match")
        XCTAssertEqual("0 KR", try! VatRate(string: "0 KR").toKsefCode(), "Ksef vat rate code must match")
        XCTAssertEqual("0 WDT", try! VatRate(string: "0 WDT").toKsefCode(), "Ksef vat rate code must match")


        XCTAssertEqual("zw", try! VatRate(string: "zw").toKsefCode(), "Ksef vat rate code must match")
        XCTAssertEqual("oo", try! VatRate(string: "oo").toKsefCode(), "Ksef vat rate code must match")
    }
    
    func testGetKsefCode_NotSupported() {
        XCTAssertThrowsError(try VatRate(string: "NPX").toKsefCode())
        XCTAssertThrowsError(try VatRate(string: "").toKsefCode())
        XCTAssertThrowsError(try VatRate(string: "0").toKsefCode())
        XCTAssertThrowsError(try VatRate(string: "0%").toKsefCode())
        XCTAssertThrowsError(try VatRate(string: "NP I").toKsefCode())
        XCTAssertThrowsError(try VatRate(string: "NP").toKsefCode())
        XCTAssertThrowsError(try VatRate(string: "OO").toKsefCode())






    }
}

