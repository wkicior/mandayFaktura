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
        XCTAssertEqual((pageLayout.itemColumnsWidths[0] + pageLayout.itemColumnsWidths[1] + pageLayout.itemColumnsWidths[2]) * pageLayout.itemsTableWidth, offset, "offset should return offset for third item")
    }
    
    func testGetColumnXOffset_sums_up_to_table_width_for_exceeding_numbers() {
        let pageLayout = PageLayout()
        let offset = pageLayout.getColumnXOffset(column: 50)
        XCTAssertTrue(abs(pageLayout.itemsTableWidth - offset) < 1, "offset should be 'equal' to table width")
    }
    
    func testGetColumnWidth_supports_all_the_columns_count() {
        let pageLayout = PageLayout()
        XCTAssertEqual(InvoiceItem.itemColumnNames.count, pageLayout.itemColumnsWidths.count, "item columns widhts must match item column names")
    }
}
