//
//  InvoiceTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 03.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura

class InvoiceTests: XCTestCase {
    
    func testTotalNetValue_for_empty_list() {
        let invoice = Invoice(issueDate: Date(), number: "", sellingDate: Date(), seller: aCounterparty(), buyer: aCounterparty(), items: [])
        XCTAssertEqual(Decimal(0), invoice.totalNetValue, "Net values must be equal")
    }
    
    func testTotalNetValue_sums_invoice_items() {
        let item1 = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .hour, unitNetPrice: Decimal(2), vatValueInPercent: Decimal(1))
        let item2 = InvoiceItem(name: "", amount: Decimal(2), unitOfMeasure: .hour, unitNetPrice: Decimal(2), vatValueInPercent: Decimal(1))
        let invoice = Invoice(issueDate: Date(), number: "", sellingDate: Date(), seller: aCounterparty(), buyer: aCounterparty(), items: [item1, item2])
        XCTAssertEqual(Decimal(6), invoice.totalNetValue, "Net values must be equal")
    }
    
    func testTotalVatValue_for_empty_list() {
        let invoice = Invoice(issueDate: Date(), number: "", sellingDate: Date(), seller: aCounterparty(), buyer: aCounterparty(), items: [])
        XCTAssertEqual(Decimal(0), invoice.totalVatValue, "VAT values must be equal")
    }
    
    func testTotalVatValue_sums_invoice_items() {
        let item1 = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .hour, unitNetPrice: Decimal(2), vatValueInPercent: Decimal(1))
        let item2 = InvoiceItem(name: "", amount: Decimal(2), unitOfMeasure: .hour, unitNetPrice: Decimal(2), vatValueInPercent: Decimal(1))
        let invoice = Invoice(issueDate: Date(), number: "", sellingDate: Date(), seller: aCounterparty(), buyer: aCounterparty(), items: [item1, item2])
        XCTAssertEqual(Decimal(string: "0.06"), invoice.totalVatValue, "Vat values must be equal")
    }
    
    func testTotalGrossValue_for_empty_list() {
        let invoice = Invoice(issueDate: Date(), number: "", sellingDate: Date(), seller: aCounterparty(), buyer: aCounterparty(), items: [])
        XCTAssertEqual(Decimal(0), invoice.totalGrossValue, "Gross values must be equal")
    }
    
    func testTotalGrossValue_sums_invoice_items() {
        let item1 = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .hour, unitNetPrice: Decimal(2), vatValueInPercent: Decimal(1))
        let item2 = InvoiceItem(name: "", amount: Decimal(2), unitOfMeasure: .hour, unitNetPrice: Decimal(2), vatValueInPercent: Decimal(1))
        let invoice = Invoice(issueDate: Date(), number: "", sellingDate: Date(), seller: aCounterparty(), buyer: aCounterparty(), items: [item1, item2])
        XCTAssertEqual(Decimal(string: "6.06"), invoice.totalGrossValue, "Gross values must be equal")
    }
    
    func aCounterparty() -> Counterparty {
        return Counterparty(name: "", streetAndNumber: "", city: "", postalCode: "", taxCode: "", accountNumber: "")
    }
}
