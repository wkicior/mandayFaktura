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
        let item = anInvoiceItem().withAmount(Decimal(1)).withUnitNetPrice(Decimal(string: "1.0")!).build()
        XCTAssertEqual(Decimal(1), item.netValue, "Net values must be equal")
    }
    
    
    func testNetValue_calculates_net_value_for_more_amount() {
        let item = anInvoiceItem().withAmount(Decimal(100)).withUnitNetPrice(Decimal(string: "1.0")!).build()
        XCTAssertEqual(Decimal(100), item.netValue, "Net values must be equal")
    }
    
    func testNetValue_calculates_net_value_for_single_amount_with_rounding_down() {
        let item = anInvoiceItem().withAmount(Decimal(1)).withUnitNetPrice(Decimal(string: "1.004")!).build()
        XCTAssertEqual(Decimal(1), item.netValue, "Net values must be equal")
    }
    
    func testNetValue_calculates_net_value_for_small_fraction_amount_with_rounding_down() {
        let item = anInvoiceItem().withAmount(Decimal(string: "0.0000001")!).withUnitNetPrice(Decimal(232243434343)).build()
        XCTAssertEqual(Decimal(string: "23224.34"), item.netValue, "Net values must be equal")
    }
    
    func testNetValue_calculates_net_value_for_single_amount_with_rounding_up() {
        let item = anInvoiceItem().withAmount(Decimal(1)).withUnitNetPrice(Decimal(string: "1.006")!).build()
        XCTAssertEqual(Decimal(string: "1.01"), item.netValue, "Net values must be equal")
    }
    
    func testNetValue_calculates_net_value_for_small_fraction_amount_with_rounding_up() {
        let item = anInvoiceItem().withAmount(Decimal(string: "0.0000001")!).withUnitNetPrice(Decimal(12340090000)).build()
        XCTAssertEqual(Decimal(string: "1234.01")!, item.netValue, "Net values must be equal")
    }
    
    func testNetValue_calculates_net_value_for_single_amount_with_rounding_half() {
        let item = anInvoiceItem().withAmount(Decimal(1)).withUnitNetPrice(Decimal(string: "1.005")!).build()
        XCTAssertEqual(Decimal(string: "1.01"), item.netValue, "Net values must be equal")
    }
    
    func testNetValue_calculates_net_value_for_small_fraction_amount_with_rounding_half() {
        let item = anInvoiceItem().withAmount(Decimal(0.0000001)).withUnitNetPrice(Decimal(12340059870)).build()
        XCTAssertEqual(Decimal(string: "1234.01"), item.netValue, "Net values must be equal")
    }
    
    func testGrossValue_calculates_gross_value_for_one_net_price() {
        let item = anInvoiceItem().withAmount(Decimal(1)).withUnitNetPrice(Decimal(string: "1.0")!).withVatRateInPercent(Decimal(23)).build()
        XCTAssertEqual(Decimal(1.23), item.grossValue, "Gross values must be equal")
    }
    
    
    func testGrossValue_calculates_gross_value_for_zero_vat() {
        let item = anInvoiceItem().withAmount(Decimal(1)).withUnitNetPrice(Decimal(string: "1.0")!).withVatRateInPercent(Decimal(0)).build()
        XCTAssertEqual(Decimal(1), item.grossValue, "Gross values must be equal")
    }
    
    func testGrossValue_calculates_gross_value_for_decimal_net_price_rounding_rounding_down() {
        let item = anInvoiceItem().withAmount(Decimal(1)).withUnitNetPrice(Decimal(string: "1.23")!).withVatRateInPercent(Decimal(23)).build()
        XCTAssertEqual(Decimal(1.51), item.grossValue, "Gross values must be equal")
    }
    
    func testGrossValue_calculates_gross_value_for_decimal_net_price_rounding_up_big_number() {
        let item = anInvoiceItem().withAmount(Decimal(1)).withUnitNetPrice(Decimal(string: "999999.99")!).withVatRateInPercent(Decimal(23)).build()
        XCTAssertEqual(Decimal(1229999.99), item.grossValue, "Gross values must be equal")
    }
    
    func testGrossValue_calculates_gross_value_for_decimal_net_price_rounding_half_up_big_number() {
        let item = anInvoiceItem().withAmount(Decimal(1)).withUnitNetPrice(Decimal(string: "111111.98")!).withVatRateInPercent(Decimal(23)).build()
        XCTAssertEqual(Decimal(136667.74), item.grossValue, "Gross values must be equal")
    }
    
    func testVatValue_for_one() {
        let item = anInvoiceItem().withAmount(Decimal(1)).withUnitNetPrice(Decimal(string: "1")!).withVatRateInPercent(Decimal(23)).build()
        XCTAssertEqual(Decimal(string: "0.23"), item.vatValue, "VAT values must be equal")
    }
}
