//
//  VatBreakdownTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura

class VatBreakdownTests: XCTestCase {
    func testEntries_returns_empty_entries_for_empty_invoice_items() {
        let breakdown = VatBreakdown(invoiceItems: [])
        XCTAssertTrue(breakdown.entries.isEmpty, "Breakdown entries should be empty")
    }
    
    func testEntries_returns_merged_entry_for_two_items_with_same_vat() {
        let item1 = InvoiceItem(name: "", amount: 1, unitOfMeasure: .hour, unitNetPrice: 1, vatValueInPercent: 23)
        let item2 = InvoiceItem(name: "", amount: 1, unitOfMeasure: .hour, unitNetPrice: 1, vatValueInPercent: 23)

        let breakdown = VatBreakdown(invoiceItems: [item1, item2])
        
        XCTAssertEqual(1, breakdown.entries.count, "Breakdown should contain one item")
        XCTAssertEqual(BreakdownEntry(vatValueInPercent: 23, netValue: 2), breakdown.entries[0])
        XCTAssertEqual(Decimal(string: "2.46"), breakdown.entries[0].grossValue)
    }
    
    func testEntries_returns_merged_entries_for_items_ordered_by_vat() {
        let item2 = InvoiceItem(name: "", amount: 2, unitOfMeasure: .hour, unitNetPrice: 15, vatValueInPercent: 23)
        let item1 = InvoiceItem(name: "", amount: 0.5, unitOfMeasure: .hour, unitNetPrice: 5, vatValueInPercent: 8)
        let item3 = InvoiceItem(name: "", amount: 3, unitOfMeasure: .hour, unitNetPrice: 1, vatValueInPercent: 23)
        
        let breakdown = VatBreakdown(invoiceItems: [item1, item2, item3])
        
        XCTAssertEqual(2, breakdown.entries.count, "Breakdown should contain two items")
        XCTAssertEqual(BreakdownEntry(vatValueInPercent: 8, netValue: Decimal(string: "2.5")!), breakdown.entries[0])
        XCTAssertEqual(Decimal(string: "2.7"), breakdown.entries[0].grossValue)
        
        XCTAssertEqual(BreakdownEntry(vatValueInPercent: 23, netValue: Decimal(string: "33")!), breakdown.entries[1])
        XCTAssertEqual(Decimal(string: "40.59"), breakdown.entries[1].grossValue)
    }
}
