//
//  NumberingTemplateTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 15.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura

class IncrementWithYearNumberingTemplateTests: XCTestCase {
    
    func testGetNextInvoiceNumber_fetches_incrementing_number_from_invoice_number() {
        let numberingTemplate = IncrementWithYearNumberingTemplate()
        let incrementingNumber = numberingTemplate.getIncrementingNumber(invoiceNumber: "1/A/2018")
        XCTAssertEqual(1, incrementingNumber!, "invoice numbers must match")
    }
    
    func testGetNextInvoiceNumber_fetches_incrementing_number_from_invoice_number_few_digits() {
        let numberingTemplate = IncrementWithYearNumberingTemplate()
        let incrementingNumber = numberingTemplate.getIncrementingNumber(invoiceNumber: "123403/A/2018")
        XCTAssertEqual(123403, incrementingNumber!, "invoice numbers must match")
    }
    
    func testGetNextInvoiceNumber_returns_nil_incrementing_number_on_not_matched_template() {
        let numberingTemplate = IncrementWithYearNumberingTemplate()
        let incrementingNumber = numberingTemplate.getIncrementingNumber(invoiceNumber: "foobar/A/2018")
        XCTAssertNil(incrementingNumber, "invoice number should be nil")
    }
    
    func testGetInvoiceNumber() {
        let numberingTemplate = IncrementWithYearNumberingTemplate()
        let invoiceNumber = numberingTemplate.getInvoiceNumber(incrementingNumber: 13)
        XCTAssertEqual("13/A/2018", invoiceNumber, "invoice numbers must match")

    }
}
