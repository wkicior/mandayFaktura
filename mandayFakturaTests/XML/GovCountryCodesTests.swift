//
//  GovCountryCodesTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 07/01/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura


class GovCountryCodesTests: XCTestCase {
    
    func testGetCountryCodeByNamePL() {
        XCTAssertEqual("PL", GovCountryCodes.getCodeByName(countryName: "pOlskA")!, "County code must match")
    }
    
    func testGetCountryCodeByNameEN() {
        XCTAssertEqual("PL", GovCountryCodes.getCodeByName(countryName: "pOlAnD")!, "County code must match")
    }
    
    func testGetCountryCodeByNameNotExisting() {
        XCTAssertTrue(GovCountryCodes.getCodeByName(countryName: "foobar") == nil, "Country code does not exists")
    }
}
