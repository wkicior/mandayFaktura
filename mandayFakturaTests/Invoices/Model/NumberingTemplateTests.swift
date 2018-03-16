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
        let numberingTemplate = IncrementWithYearNumberingTemplate(delimeter: "/", fixedPart: "B", ordering: [.incrementingNumber, .fixedPart, .year])
        let incrementingNumber = numberingTemplate.getIncrementingNumber(invoiceNumber: "1/B/2018")
        XCTAssertEqual(1, incrementingNumber!, "invoice numbers must match")
    }
    
    func testGetNextInvoiceNumber_fetches_incrementing_number_from_invoice_number_different_ordering() {
        let numberingTemplate = IncrementWithYearNumberingTemplate(delimeter: "/", fixedPart: "B", ordering: [.year, .incrementingNumber, .fixedPart])
        let incrementingNumber = numberingTemplate.getIncrementingNumber(invoiceNumber: "2018/9/B")
        XCTAssertEqual(9, incrementingNumber!, "invoice numbers must match")
    }
    
    func testGetNextInvoiceNumber_fetches_incrementing_number_from_invoice_number_redudant_ordering() {
        let numberingTemplate = IncrementWithYearNumberingTemplate(delimeter: "/", fixedPart: "B", ordering: [.year, .incrementingNumber, .year, .fixedPart])
        let incrementingNumber = numberingTemplate.getIncrementingNumber(invoiceNumber: "2018/9/2018/B")
        XCTAssertEqual(9, incrementingNumber!, "invoice numbers must match")
    }
    
    func testGetNextInvoiceNumber_fetches_incrementing_number_from_invoice_number_few_digits() {
        let numberingTemplate = IncrementWithYearNumberingTemplate(delimeter: "-", fixedPart: "A", ordering: [.incrementingNumber, .fixedPart, .year])
        let incrementingNumber = numberingTemplate.getIncrementingNumber(invoiceNumber: "123403-A-2018")
        XCTAssertEqual(123403, incrementingNumber!, "invoice numbers must match")
    }
    
    func testGetNextInvoiceNumber_returns_nil_incrementing_number_on_not_matched_template() {
        let numberingTemplate = IncrementWithYearNumberingTemplate(delimeter: "/", fixedPart: "A", ordering: [.incrementingNumber, .fixedPart, .year])
        let incrementingNumber = numberingTemplate.getIncrementingNumber(invoiceNumber: "foobar/A/2018")
        XCTAssertNil(incrementingNumber, "invoice number should be nil")
    }
    
    func testGetInvoiceNumber() {
        let numberingTemplate = IncrementWithYearNumberingTemplate(delimeter: "/", fixedPart: "A", ordering: [.incrementingNumber, .fixedPart, .year])
        let invoiceNumber = numberingTemplate.getInvoiceNumber(incrementingNumber: 13)
        XCTAssertEqual("13/A/2018", invoiceNumber, "invoice numbers must match")

    }
    
    func testGetInvoiceNumber_different_ordering() {
        let numberingTemplate = IncrementWithYearNumberingTemplate(delimeter: "/", fixedPart: "B", ordering: [.year, .incrementingNumber, .fixedPart])
        let invoiceNumber = numberingTemplate.getInvoiceNumber(incrementingNumber: 13)
        XCTAssertEqual("2018/13/B", invoiceNumber, "invoice numbers must match")
    }
    
    func testGetInvoiceNumber_redudant_ordering() {
        let numberingTemplate = IncrementWithYearNumberingTemplate(delimeter: "/", fixedPart: "B", ordering: [.fixedPart, .year, .incrementingNumber, .fixedPart])
        let invoiceNumber = numberingTemplate.getInvoiceNumber(incrementingNumber: 13)
        XCTAssertEqual("B/2018/13/B", invoiceNumber, "invoice numbers must match")
    }
}
