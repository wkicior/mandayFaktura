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
        let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(1).withVatRateInPercent(23).build()
        let item2 = anInvoiceItem().withAmount(1).withUnitNetPrice(1).withVatRateInPercent(23).build()

        let breakdown = VatBreakdown(invoiceItems: [item1, item2])
        
        XCTAssertEqual(1, breakdown.entries.count, "Breakdown should contain one item")
        XCTAssertEqual(BreakdownEntry(vatRateInPercent: 23, netValue: 2), breakdown.entries[0])
        XCTAssertEqual(Decimal(string: "2.46"), breakdown.entries[0].grossValue)
    }
    
    func testEntries_returns_merged_entries_for_items_ordered_by_vat() {
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(15).withVatRateInPercent(23).build()
        let item1 = anInvoiceItem().withAmount(0.5).withUnitNetPrice(5).withVatRateInPercent(8).build()
        let item3 = anInvoiceItem().withAmount(3).withUnitNetPrice(1).withVatRateInPercent(23).build()

        let breakdown = VatBreakdown(invoiceItems: [item1, item2, item3])
        
        XCTAssertEqual(2, breakdown.entries.count, "Breakdown should contain two items")
        XCTAssertEqual(BreakdownEntry(vatRateInPercent: 8, netValue: Decimal(string: "2.5")!), breakdown.entries[0])
        XCTAssertEqual(Decimal(string: "2.7"), breakdown.entries[0].grossValue)
        
        XCTAssertEqual(BreakdownEntry(vatRateInPercent: 23, netValue: Decimal(string: "33")!), breakdown.entries[1])
        XCTAssertEqual(Decimal(string: "40.59"), breakdown.entries[1].grossValue)
    }
}
