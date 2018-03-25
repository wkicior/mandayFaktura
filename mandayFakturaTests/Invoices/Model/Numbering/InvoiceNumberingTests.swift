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

class MockInvoiceRepository: InvoiceRepository {
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

class MockNumberingCoder: NumberingCoder {
    func decodeNumber(invoiceNumber: String) -> [NumberingSegmentValue]? {
        return [NumberingSegmentValue(type: .fixedPart, value: "A"), NumberingSegmentValue(type: .incrementingNumber, value: "1")]
    }
    
    func encodeNumber(segments: [NumberingSegmentValue]) -> String {
        return segments.map({s in s.value}).joined(separator: "-")
    }
}

class InvoiceNumberingTests: XCTestCase {
    
    func testGetNextInvoiceNumber_generates_fresh_invoice_number_if_no_invoice_found() {
        let mockInvoiceRepository = MockInvoiceRepository(invoices: [])
        InvoiceRepositoryFactory.register(repository: mockInvoiceRepository)
        let invoiceNumbering = InvoiceNumbering()
        invoiceNumbering.numberingCoder = MockNumberingCoder()
        invoiceNumbering.settings = settings
        XCTAssertEqual("A-1", invoiceNumbering.nextInvoiceNumber, "invoice numbers must match")
    }
    
    func testGetNextInvoiceNumber_generates_fresh_invoice_number_if_failed_to_parse_previous_number() {
        let mockInvoiceRepository = MockInvoiceRepository(invoices: [])
        InvoiceRepositoryFactory.register(repository: mockInvoiceRepository)
        let invoiceNumbering = InvoiceNumbering()
        invoiceNumbering.numberingCoder = MockNumberingCoder()
        invoiceNumbering.settings = settings
        XCTAssertEqual("A-1", invoiceNumbering.nextInvoiceNumber, "invoice numbers must match")
    }
    
    func testGetNextInvoiceNumber_increments_invoice_number_on_previous_invoice_found() {
        let mockInvoiceRepository = MockInvoiceRepository(invoices: [aTestInvoice.withNumber("A-1").build()])
        InvoiceRepositoryFactory.register(repository: mockInvoiceRepository)
        let invoiceNumbering = InvoiceNumbering()
        invoiceNumbering.numberingCoder = MockNumberingCoder()
        invoiceNumbering.settings = settings
        XCTAssertEqual("A-2", invoiceNumbering.nextInvoiceNumber, "invoice number should be incremented")
    }
    
    var settings: InvoiceNumberingSettings {
        get {
            return InvoiceNumberingSettings(separator: "-", segments:[NumberingSegment(type: .fixedPart, value: "A"), NumberingSegment(type: .incrementingNumber)])
        }
    }
    
    var aTestInvoice: InvoiceBuilder {
        get {
            return anInvoice().withBuyer(aCounterparty().build()).withSeller(aCounterparty().build())
        }
    }
}
