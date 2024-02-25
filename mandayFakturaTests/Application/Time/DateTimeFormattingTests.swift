//
//  DateTimeFormattingTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 07/01/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura


class DateTimeFormattingTests: XCTestCase {
    
    func testToDateDotString() {
        let date = Date(timeIntervalSince1970: 1704627369)
        XCTAssertEqual("7.01.2024", date.toDateDotString(), "Dates must match")
    }
    
    func testToDateBigEndianDashString() {
        let date = Date(timeIntervalSince1970: 1704627369)
        XCTAssertEqual("2024-01-07", date.toDateBigEndianDashString(), "Dates must match")
    }
    
    func testToIsoString() {
        let date = Date(timeIntervalSince1970: 1704627369)
        XCTAssertEqual("2024-01-07T12:36:09.000+01:00", date.toIsoString(), "Datetime must match")
    }
}
