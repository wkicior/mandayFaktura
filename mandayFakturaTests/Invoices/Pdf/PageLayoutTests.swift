//
//  PageLayoutTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 06.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

import XCTest
@testable import mandayFaktura

class PageLayoutTests: XCTestCase {
    func testGetColumnXOffset_should_return_0_for_0_column() {
        let pageLayout = PageLayout()
        let offset = pageLayout.getColumnXOffset(column: 0)
        XCTAssertEqual(CGFloat(), offset, "offset should return 0 for first item")
    }
    
    func testGetColumnXOffset_should_return_sum_of_widths_for_previous_columns() {
        let pageLayout = PageLayout()
        let offset = pageLayout.getColumnXOffset(column: 3)
        XCTAssertEqual((pageLayout.columnWidths[0] + pageLayout.columnWidths[1] + pageLayout.columnWidths[2]) * pageLayout.itemsTableWidth, offset, "offset should return offset for third item")
    }
}
