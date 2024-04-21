//
//  KsefNumberTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 21/04/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura


class KsefNumberTests: XCTestCase {
    func testInit() {
        let ksefNumberString = "2130035973-22291030-5AD56D1D5329-B0"
        let ksefNumber = try! KsefNumber(ksefNumberString)
        XCTAssertEqual(ksefNumberString, ksefNumber.stringValue, "Numbers must match")
    }
    
    func testInitInvalid() {
        let ksefNumberString = "foo-bar"
        var exceptionThrown = false
        do {
            let ksefNumber = try KsefNumber(ksefNumberString)
        } catch KsefNumberError.invalidKsefNumber(let number) {
            exceptionThrown = true
            XCTAssertEqual(ksefNumberString, number, "Numbers must match")
        } catch {
            //
        }
        XCTAssertEqual(true, exceptionThrown, "Exception must be thrown")

    }
}
