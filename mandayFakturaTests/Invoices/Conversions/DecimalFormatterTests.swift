//
//  DecimalFormatterTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 14.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

import XCTest
@testable import mandayFaktura

class DecimalFormatterTests: XCTestCase {
    func test_formatAmount_int_number() {
        XCTAssertEqual("1,00", Decimal(1).formatAmount())
    }
    
    func test_formatAmount_decimal_number() {
        XCTAssertEqual("1,23", Decimal(1.23).formatAmount())
    }
    
    func test_formatAmount_decimal_number_over_precission() {
        XCTAssertEqual("1,23", Decimal(1.23499999).formatAmount())
    }
    
    func test_formatAmount_on_item_net_value_calculation_for_small_fraction_amount_with_rounding_half() {
        let item = anInvoiceItem().withAmount(Decimal(0.0000001)).withUnitNetPrice(Decimal(12340059870)).build()
        XCTAssertEqual("1 234,01", item.netValue.formatAmount(), "Net values must be equal") //nbsp (option+space)
    }
    
    func test_formatAmount_on_item_net_value_calculation_for_small_fraction_amount_with_rounding_down() {
        let item = anInvoiceItem().withAmount(Decimal(0.0000001)).withUnitNetPrice(Decimal(12340049870)).build()
        XCTAssertEqual("1 234,00", item.netValue.formatAmount(), "Net values must be equal") //nbsp (option+space)
    }
}
