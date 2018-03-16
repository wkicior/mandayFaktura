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

class MockNumberingTemplate: NumberingTemplate {
    func getInvoiceNumber(incrementingNumber: Int) -> String {
        return "A-\(incrementingNumber.description)"
    }
    
    func getIncrementingNumber(invoiceNumber: String) -> Int? {
        return Int(invoiceNumber.split(separator: "-")[1])
    }
}

class InvoiceNumberingTests: XCTestCase {
    
    func testGetNextInvoiceNumber_generates_fresh_invoice_number_if_no_invoice_found() {
        let mockInvoiceRepository = MockInvoiceRepository(invoices: [])
        InvoiceRepositoryFactory.register(repository: mockInvoiceRepository)
        let invoiceNumbering = InvoiceNumbering()
        invoiceNumbering.numberingTemplate = MockNumberingTemplate()
        XCTAssertEqual("A-1", invoiceNumbering.nextInvoiceNumber, "invoice numbers must match")
    }
    
    func testGetNextInvoiceNumber_increments_invoice_number_on_previous_invoice_found() {
        let mockInvoiceRepository = MockInvoiceRepository(invoices: [aTestInvoice().withNumber("A-1").build()])
        InvoiceRepositoryFactory.register(repository: mockInvoiceRepository)
        let invoiceNumbering = InvoiceNumbering()
        invoiceNumbering.numberingTemplate = MockNumberingTemplate()
        XCTAssertEqual("A-2", invoiceNumbering.nextInvoiceNumber, "invoice number should be incremented")
    }
    
    func aTestInvoice() -> InvoiceBuilder {
        return anInvoice().withBuyer(aCounterparty().build()).withSeller(aCounterparty().build())
    }
}
