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
        let breakdown = VatBreakdown.fromInvoiceItems(invoiceItems: [])
        XCTAssertTrue(breakdown.entries.isEmpty, "Breakdown entries should be empty")
    }
    
    func testEntries_returns_merged_entry_for_two_items_with_same_vat() {
        let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(1).withVatRate(VatRate(value: 0.23)).build()
        let item2 = anInvoiceItem().withAmount(1).withUnitNetPrice(1).withVatRate(VatRate(value: 0.23)).build()

        let breakdown = VatBreakdown.fromInvoiceItems(invoiceItems: [item1, item2])
        
        XCTAssertEqual(1, breakdown.entries.count, "Breakdown should contain one item")
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0.23), netValue: 2), breakdown.entries[0])
        XCTAssertEqual(Decimal(string: "2.46"), breakdown.entries[0].grossValue)
    }
    
    func testEntries_separates_special_values() {
        let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(1).withVatRate(VatRate(value: 0)).build()
        let item2 = anInvoiceItem().withAmount(1).withUnitNetPrice(1).withVatRate(VatRate(value: 0, literal: "nd.")).build()
        let item3 = anInvoiceItem().withAmount(2).withUnitNetPrice(1).withVatRate(VatRate(value: 0, literal: "nd.")).build()
        let item4 = anInvoiceItem().withAmount(1).withUnitNetPrice(1).withVatRate(VatRate(value: 0)).build()


        
        let breakdown = VatBreakdown.fromInvoiceItems(invoiceItems: [item1, item2, item3, item4])
        
        XCTAssertEqual(2, breakdown.entries.count, "Breakdown should contain two items")
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0), netValue: 2), breakdown.entries[0])
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0, literal: "nd."), netValue: 3), breakdown.entries[1])
    }
    
    func testEntries_returns_merged_entries_for_items_ordered_by_vat() {
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(15).withVatRate(VatRate(value: 0.23)).build()
        let item1 = anInvoiceItem().withAmount(0.5).withUnitNetPrice(5).withVatRate(VatRate(value: 0.08)).build()
        let item3 = anInvoiceItem().withAmount(3).withUnitNetPrice(1).withVatRate(VatRate(value: 0.23)).build()

        let breakdown = VatBreakdown.fromInvoiceItems(invoiceItems: [item1, item2, item3])
        
        XCTAssertEqual(2, breakdown.entries.count, "Breakdown should contain two items")
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0.08), netValue: Decimal(string: "2.5")!), breakdown.entries[0])
        XCTAssertEqual(Decimal(string: "2.7"), breakdown.entries[0].grossValue)
        
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0.23), netValue: Decimal(string: "33")!), breakdown.entries[1])
        XCTAssertEqual(Decimal(string: "40.59"), breakdown.entries[1].grossValue)
    }
    
    func testMinusOperand_returns_LHS_minus_RHS_values_on_entries_matched() {
        //given
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(15).withVatRate(VatRate(value: 0.23)).build()
        let item1 = anInvoiceItem().withAmount(0.5).withUnitNetPrice(5).withVatRate(VatRate(value: 0.08)).build()
        let breakdownLhs = VatBreakdown.fromInvoiceItems(invoiceItems: [item1, item2])
        let item3 = anInvoiceItem().withAmount(2).withUnitNetPrice(5).withVatRate(VatRate(value: 0.08)).build()
        let item4 = anInvoiceItem().withAmount(2).withUnitNetPrice(10).withVatRate(VatRate(value: 0.00)).build()
        let breakdownRhs = VatBreakdown.fromInvoiceItems(invoiceItems: [item2, item3, item4])
        //when
        let resultBreakdown = breakdownLhs - breakdownRhs
        let sortedResult = resultBreakdown.entries.sorted(by: {$0.vatRate.literal > $1.vatRate.literal})

        //then
        XCTAssertEqual(3, resultBreakdown.entries.count, "Breakdown should contain thres items")
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0.08), netValue: Decimal(string: "-7.5")!), sortedResult[0])
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0.23), netValue: Decimal(string: "0")!), sortedResult[1])
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0.00), netValue: Decimal(string: "-20")!), sortedResult[2])

        
    }
    
    func testPlusOperand_returns_LHS_plus_RHS_values() {
        //given
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(15).withVatRate(VatRate(value: 0.23)).build()
        let item1 = anInvoiceItem().withAmount(0.5).withUnitNetPrice(5).withVatRate(VatRate(value: 0.08)).build()
        let breakdownLhs = VatBreakdown.fromInvoiceItems(invoiceItems: [item1, item2])
        let item3 = anInvoiceItem().withAmount(2).withUnitNetPrice(5).withVatRate(VatRate(value: 0.08)).build()
         let item4 = anInvoiceItem().withAmount(2).withUnitNetPrice(5).withVatRate(VatRate(value: 0.00)).build()
        let breakdownRhs = VatBreakdown.fromInvoiceItems(invoiceItems: [item3, item4])
        //when
        let resultBreakdown = breakdownLhs + breakdownRhs
        //then
        let sortedResult = resultBreakdown.entries.sorted(by: {$0.vatRate.literal > $1.vatRate.literal})
        XCTAssertEqual(3, sortedResult.count, "Breakdown should contain three items")
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0.23), netValue: Decimal(string: "30")!), sortedResult[1])
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0.08), netValue: Decimal(string: "12.5")!), sortedResult[0])
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0.00), netValue: Decimal(string: "10")!), sortedResult[2])
    }
    
    func testPlusOperand_returns_emptyBreakdown_on_empty_RHS_and_LHS() {
        //given
        let breakdownLhs = VatBreakdown.fromInvoiceItems(invoiceItems: [])
        let breakdownRhs = VatBreakdown.fromInvoiceItems(invoiceItems: [])
        //when
        let resultBreakdown = breakdownLhs + breakdownRhs
        //then
        XCTAssertEqual(0, resultBreakdown.entries.count, "Breakdown should contain no elements")
    }
    
    func testPlusOperand_returns_LHS_if_RHS_empty() {
        //given
        let item1 = anInvoiceItem().withAmount(0.5).withUnitNetPrice(5).withVatRate(VatRate(value: 0.08)).build()
        let breakdownLhs = VatBreakdown.fromInvoiceItems(invoiceItems: [item1])
        let breakdownRhs = VatBreakdown.fromInvoiceItems(invoiceItems: [])
        //when
        let resultBreakdown = breakdownLhs + breakdownRhs
        //then
        XCTAssertEqual(breakdownLhs.entries, resultBreakdown.entries, "Breakdown entries should match lhs")
    }
    
    func testPlusOperand_returns_RHS_if_LHS_empty() {
        //given
        let breakdownLhs = VatBreakdown.fromInvoiceItems(invoiceItems: [])
        let item1 = anInvoiceItem().withAmount(0.5).withUnitNetPrice(5).withVatRate(VatRate(value: 0.08)).build()
        let breakdownRhs = VatBreakdown.fromInvoiceItems(invoiceItems: [item1])
        //when
        let resultBreakdown = breakdownLhs + breakdownRhs
        //then
        XCTAssertEqual(breakdownRhs.entries, resultBreakdown.entries, "Breakdown entries should match rhs")
    }
    
    func testMultiplyOperand_returns_vat_breakdown_with_multiplied_net_values() {
        //given
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(15).withVatRate(VatRate(value: 0.23)).build()
        let item1 = anInvoiceItem().withAmount(0.5).withUnitNetPrice(5).withVatRate(VatRate(value: 0.08)).build()
        let breakdown = VatBreakdown.fromInvoiceItems(invoiceItems: [item1, item2])
        //when
        let resultBreakdown = 2 * breakdown
        //then
        let sortedResult = resultBreakdown.entries.sorted(by: {$0.vatRate.literal > $1.vatRate.literal})
        XCTAssertEqual(2, resultBreakdown.entries.count, "Breakdown should contain two items")
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0.08), netValue: Decimal(string: "5")!), sortedResult[0])
        XCTAssertEqual(BreakdownEntry(vatRate: VatRate(value: 0.23), netValue: Decimal(string: "60")!), sortedResult[1])

    }
}
