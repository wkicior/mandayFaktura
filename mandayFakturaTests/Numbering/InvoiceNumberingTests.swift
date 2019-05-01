//
//  InvoiceNumberingTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 12.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura

fileprivate class MockInvoiceRepository: InvoiceRepository {
    func findBy(invoiceNumber: String) -> Invoice? {
        return self.invoices[0]
    }
    
    func getInvoice(number: String) -> Invoice {
        return self.invoices[0]
    }
    
    func editInvoice(old: Invoice, new: Invoice) {
        //
    }
    
    let invoices: [Invoice]
    
    init(invoices: [Invoice]) {
        self.invoices = invoices
    }
    func getLastInvoice() -> Invoice? {
        return self.invoices.last
    }
    
    func getInvoices() -> [Invoice] {
        return []
    }
    
    func addInvoice(_ invoice: Invoice) {
        //
    }
    
    func delete(_ invoice: Invoice) {
        //
    }
}

class MockInvoiceNumberingSettingsRepository: InvoiceNumberingSettingsRepository {
    let invoiceNumberingSettings: InvoiceNumberingSettings
    
    init(invoiceNumberingSettings: InvoiceNumberingSettings = InvoiceNumberingSettings(separator: "/", segments: [], resetOnYearChange: true) ) {
        self.invoiceNumberingSettings = invoiceNumberingSettings
    }
    func getInvoiceNumberingSettings() -> InvoiceNumberingSettings? {
        return self.invoiceNumberingSettings
    }
    
    func save(invoiceNumberingSettings: InvoiceNumberingSettings) {
        //
    }
}

class MockNumberingCoder: NumberingCoder {
    let numberSegments: [NumberingSegmentValue]?
    init(numberSegments: [NumberingSegmentValue]? = [NumberingSegmentValue(type: .fixedPart, value: "A"), NumberingSegmentValue(type: .incrementingNumber, value: "1")]) {
        self.numberSegments = numberSegments
    }
    func decodeNumber(invoiceNumber: String) -> [NumberingSegmentValue]? {
        return self.numberSegments
    }
    
    func encodeNumber(segments: [NumberingSegmentValue]) -> String {
        return segments.map({s in s.value}).joined(separator: "-")
    }
}

class InvoiceNumberingTests: XCTestCase {
    
    func testGetNextInvoiceNumber_generates_fresh_invoice_number_if_no_invoice_found() {
        let mockInvoiceRepository = MockInvoiceRepository(invoices: [])
        let mockInvoiceNumberingSettingsRepository = MockInvoiceNumberingSettingsRepository()
        let invoiceNumbering = InvoiceNumbering(invoiceRepository: mockInvoiceRepository, invoiceNumberingSettingsRepository: mockInvoiceNumberingSettingsRepository)
        invoiceNumbering.numberingCoder = MockNumberingCoder()
        invoiceNumbering.settings = settings
        XCTAssertEqual("A-1", invoiceNumbering.nextInvoiceNumber, "invoice numbers must match")
    }
    
    func testGetNextInvoiceNumber_generates_fresh_invoice_number_if_failed_to_parse_previous_number() {
        let mockInvoiceRepository = MockInvoiceRepository(invoices: [])
        let mockInvoiceNumberingSettingsRepository = MockInvoiceNumberingSettingsRepository()
        let invoiceNumbering = InvoiceNumbering(invoiceRepository: mockInvoiceRepository, invoiceNumberingSettingsRepository: mockInvoiceNumberingSettingsRepository)
        invoiceNumbering.numberingCoder = MockNumberingCoder()
        invoiceNumbering.settings = settings
        XCTAssertEqual("A-1", invoiceNumbering.nextInvoiceNumber, "invoice numbers must match")
    }
    
    func testGetNextInvoiceNumber_increments_invoice_number_on_previous_invoice_found() {
        let mockInvoiceRepository = MockInvoiceRepository(invoices: [aTestInvoice.withNumber("A-1").build()])
        let mockInvoiceNumberingSettingsRepository = MockInvoiceNumberingSettingsRepository()
        let invoiceNumbering = InvoiceNumbering(invoiceRepository: mockInvoiceRepository, invoiceNumberingSettingsRepository: mockInvoiceNumberingSettingsRepository)
        invoiceNumbering.numberingCoder = MockNumberingCoder()
        invoiceNumbering.settings = settings
        XCTAssertEqual("A-2", invoiceNumbering.nextInvoiceNumber, "invoice number should be incremented")
    }
    
    func testGetNextInvoiceNumber_resets_invoice_number_on_previous_invoice_found_and_year_got_changed_and_resetOnYearOption_in_settings_is_enabled() {
        let segments: [NumberingSegment]  = [NumberingSegment(type: .year), NumberingSegment(type: .incrementingNumber)]
        let mockInvoiceRepository = MockInvoiceRepository(invoices: [aTestInvoice.withNumber("2015/2").build()])
        let mockInvoiceNumberingSettingsRepository = MockInvoiceNumberingSettingsRepository(invoiceNumberingSettings: InvoiceNumberingSettings(separator: "/", segments: segments, resetOnYearChange: true))
        let invoiceNumbering = InvoiceNumbering(invoiceRepository: mockInvoiceRepository, invoiceNumberingSettingsRepository: mockInvoiceNumberingSettingsRepository)
        invoiceNumbering.numberingCoder = MockNumberingCoder(numberSegments: [
            NumberingSegmentValue(type: .year, value: "2015"),
            NumberingSegmentValue(type: .incrementingNumber, value: "2")
        ])
        XCTAssertEqual(String(Date().year) + "-1", invoiceNumbering.nextInvoiceNumber, "invoice number should be incremented")
    }
    
    func testGetNextInvoiceNumber_gets_fresh_invoice_number_on_resetOnYearOption_in_settings_is_enabled() {
        let segments: [NumberingSegment]  = [NumberingSegment(type: .year), NumberingSegment(type: .incrementingNumber)]
        let mockInvoiceRepository = MockInvoiceRepository(invoices: [])
        let mockInvoiceNumberingSettingsRepository = MockInvoiceNumberingSettingsRepository(invoiceNumberingSettings: InvoiceNumberingSettings(separator: "/", segments: segments, resetOnYearChange: true))
        let invoiceNumbering = InvoiceNumbering(invoiceRepository: mockInvoiceRepository, invoiceNumberingSettingsRepository: mockInvoiceNumberingSettingsRepository)
        XCTAssertEqual(String(Date().year) + "/1", invoiceNumbering.nextInvoiceNumber, "invoice number should be incremented")
    }
    
    func testGetNextInvoiceNumber_increments_invoice_number_on_previous_invoice_found_and_year_got_changed_but_resetOnYearOption_in_settings_is_disabled() {
        let segments: [NumberingSegment]  = [NumberingSegment(type: .year), NumberingSegment(type: .incrementingNumber)]
        let mockInvoiceRepository = MockInvoiceRepository(invoices: [aTestInvoice.withNumber("2015/2").build()])
        let mockInvoiceNumberingSettingsRepository = MockInvoiceNumberingSettingsRepository(invoiceNumberingSettings: InvoiceNumberingSettings(separator: "/", segments: segments, resetOnYearChange: false))
        let invoiceNumbering = InvoiceNumbering(invoiceRepository: mockInvoiceRepository, invoiceNumberingSettingsRepository: mockInvoiceNumberingSettingsRepository)
        invoiceNumbering.numberingCoder = MockNumberingCoder(numberSegments: [
            NumberingSegmentValue(type: .year, value: "2015"),
            NumberingSegmentValue(type: .incrementingNumber, value: "2")
            ])
        XCTAssertEqual(String(Date().year) + "-3", invoiceNumbering.nextInvoiceNumber, "invoice number should be incremented")
    }
    
    var settings: InvoiceNumberingSettings {
        get {
            return InvoiceNumberingSettings(separator: "-", segments:[NumberingSegment(type: .fixedPart, value: "A"), NumberingSegment(type: .incrementingNumber)], resetOnYearChange: false)
        }
    }
    
    var aTestInvoice: InvoiceBuilder {
        get {
            return anInvoice().withBuyer(aCounterparty().build()).withSeller(aCounterparty().build())
        }
    }
}
