//
//  InvoiceItemTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 01.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

import XCTest
@testable import mandayFaktura

class InvoiceItemTests: XCTestCase {
    
    func testNetValue_calculates_net_value_for_one_amount() {
        let item = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(string: "1.0")!, vatValueInPercent: Decimal(23))
        XCTAssertEqual(Decimal(1), item.netValue, "Net values must be equal")
    }
    
    
    func testNetValue_calculates_net_value_for_more_amount() {
        let item = InvoiceItem(name: "", amount: Decimal(100), unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(string: "1.0")!, vatValueInPercent: Decimal(23))
        XCTAssertEqual(Decimal(100), item.netValue, "Net values must be equal")
        
    }
    
    func testNetValue_calculates_net_value_for_single_amount_with_rounding_down() {
        let item = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(string: "1.004")!, vatValueInPercent: Decimal(23))
        XCTAssertEqual(Decimal(1), item.netValue, "Net values must be equal")
    }
    
    func testNetValue_calculates_net_value_for_small_fraction_amount_with_rounding_down() {
        let item = InvoiceItem(name: "", amount: Decimal(string: "0.0000001")!, unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(232243434343), vatValueInPercent: Decimal(23))
            XCTAssertEqual(Decimal(string: "23224.34"), item.netValue, "Net values must be equal")
    }
    
    func testNetValue_calculates_net_value_for_single_amount_with_rounding_up() {
        let item = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(string: "1.006")!, vatValueInPercent: Decimal(23))
        XCTAssertEqual(Decimal(string: "1.01"), item.netValue, "Net values must be equal")
    }
    
    func testNetValue_calculates_net_value_for_small_fraction_amount_with_rounding_up() {
        let item = InvoiceItem(name: "", amount: Decimal(string: "0.0000001")!, unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(12340090000), vatValueInPercent: Decimal(23))
        XCTAssertEqual(Decimal(string: "1234.01")!, item.netValue, "Net values must be equal")
    }
    
    func testNetValue_calculates_net_value_for_single_amount_with_rounding_half() {
        let item = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(string: "1.005")!, vatValueInPercent: Decimal(23))
        XCTAssertEqual(Decimal(string: "1.01"), item.netValue, "Net values must be equal")
    }
    
    func testNetValue_calculates_net_value_for_small_fraction_amount_with_rounding_half() {
        let item = InvoiceItem(name: "", amount: Decimal(0.0000001), unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(12340059870), vatValueInPercent: Decimal(23))
        XCTAssertEqual(Decimal(string: "1234.01"), item.netValue, "Net values must be equal")
    }
    
    func testGrossValue_calculates_gross_value_for_one_net_price() {
        let item = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(string: "1.0")!, vatValueInPercent: Decimal(23))
        XCTAssertEqual(Decimal(1.23), item.grossValue, "Net values must be equal")
    }
    
    
    func testGrossValue_calculates_gross_value_for_zero_vat() {
        let item = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(string: "1.0")!, vatValueInPercent: Decimal(0))
        XCTAssertEqual(Decimal(1), item.grossValue, "Net values must be equal")
    }
    
    func testGrossValue_calculates_gross_value_for_decimal_net_price_rounding_rounding_down() {
        let item = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(string: "1.23")!, vatValueInPercent: Decimal(23))
        XCTAssertEqual(Decimal(1.51), item.grossValue, "Net values must be equal")
    }
    
    func testGrossValue_calculates_gross_value_for_decimal_net_price_rounding_up_big_number() {
        let item = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(string: "999999.99")!, vatValueInPercent: Decimal(23))
        XCTAssertEqual(Decimal(1229999.99), item.grossValue, "Net values must be equal")
    }
    
    func testGrossValue_calculates_gross_value_for_decimal_net_price_rounding_half_up_big_number() {
        let item = InvoiceItem(name: "", amount: Decimal(1), unitOfMeasure: .pieces,
                               unitNetPrice: Decimal(string: "111111.98")!, vatValueInPercent: Decimal(23))
        XCTAssertEqual(Decimal(136667.74), item.grossValue, "Net values must be equal")
    }
}
