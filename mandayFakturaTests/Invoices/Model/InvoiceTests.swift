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
    
    fileprivate func anInvoice() -> InvoiceBuilder {
        return InvoiceBuilder()
    }
    
    func testTotalNetValue_for_empty_list() {
        let invoice = anInvoice()
            .withItems([])
            .withSeller(aCounterparty())
            .withBuyer(aCounterparty())
            .build()
        XCTAssertEqual(Decimal(0), invoice.totalNetValue, "Net values must be equal")
    }
    
    func testTotalNetValue_sums_invoice_items() {
        let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(2).build()
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(2).build()
        let invoice = anInvoice()
            .withItems([item1, item2])
            .withSeller(aCounterparty())
            .withBuyer(aCounterparty())
            .build()
        XCTAssertEqual(Decimal(6), invoice.totalNetValue, "Net values must be equal")
    }
    
    func testTotalVatValue_for_empty_list() {
        let invoice = anInvoice()
            .withItems([])
            .withSeller(aCounterparty())
            .withBuyer(aCounterparty())
            .build()
        XCTAssertEqual(Decimal(0), invoice.totalVatValue, "VAT values must be equal")
    }
    
    func testTotalVatValue_sums_invoice_items() {
        let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(2).withVatRate(VatRate(value: 0.01)).build()
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(2).withVatRate(VatRate(value: 0.01)).build()
        
        let invoice = anInvoice()
            .withItems([item1, item2])
            .withSeller(aCounterparty())
            .withBuyer(aCounterparty())
            .build()
        XCTAssertEqual(Decimal(string: "0.06"), invoice.totalVatValue, "Vat values must be equal")
    }
    
    func testTotalGrossValue_for_empty_list() {
        let invoice = anInvoice()
            .withItems([])
            .withSeller(aCounterparty())
            .withBuyer(aCounterparty())
            .build()
        XCTAssertEqual(Decimal(0), invoice.totalGrossValue, "Gross values must be equal")
    }
    
    func testTotalGrossValue_sums_invoice_items() {
        let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(2).withVatRate(VatRate(value: 0.01)).build()
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(2).withVatRate(VatRate(value: 0.01)).build()
        let invoice = anInvoice()
            .withItems([item1, item2])
            .withSeller(aCounterparty())
            .withBuyer(aCounterparty())
            .build()
        XCTAssertEqual(Decimal(string: "6.06"), invoice.totalGrossValue, "Gross values must be equal")
    }
    
    func testMightMissReverseChargeReturnsTrueIfIsInternationalAndOneInvoiceItemIsVAT0AndReverseChargeIsNotSet() {
        let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(2).withVatRate(VatRate(value: 0.01)).build()
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(2).withVatRate(VatRate(string: "N/P")).build()
        let invoice = anInvoice()
            .withItems([item1, item2])
            .withSeller(CounterpartyBuilder().withCountry("Poland").build())
            .withBuyer(CounterpartyBuilder().withCountry("Denmark").build())
            .build()
        let classifiesForReverseCharge = invoice.mightMissReverseCharge()
        XCTAssertTrue(classifiesForReverseCharge)
    }
    
    func testMightMissReverseChargeReturnsFalseIfReverseChargeIsSet() {
        let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(2).withVatRate(VatRate(value: 0.01)).build()
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(2).withVatRate(VatRate(string: "N/P")).build()
        let invoice = anInvoice()
            .withItems([item1, item2])
            .withReverseCharge(true)
            .withSeller(CounterpartyBuilder().withCountry("Poland").build())
            .withBuyer(CounterpartyBuilder().withCountry("Denmark").build())
            .build()
        let classifiesForReverseCharge = invoice.mightMissReverseCharge()
        XCTAssertFalse(classifiesForReverseCharge)
    }
    
    func testMightMissReverseChargeReturnsFalseIfInvoiceIsNotInternational() {
        let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(2).withVatRate(VatRate(value: 0.01)).build()
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(2).withVatRate(VatRate(string: "N/P")).build()
        let invoice = anInvoice()
            .withItems([item1, item2])
            .withSeller(CounterpartyBuilder().withCountry("Polska").build())
            .withBuyer(CounterpartyBuilder().withCountry("Polska").build())
            .build()
        let classifiesForReverseCharge = invoice.mightMissReverseCharge()
        XCTAssertFalse(classifiesForReverseCharge)
    }
    
    func testMightMissReverseChargeReturnsFalseIfInvoiceItemsAreNot0VAy() {
           let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(2).withVatRate(VatRate(value: 0.01)).build()
        let item2 = anInvoiceItem().withAmount(2).withUnitNetPrice(2).withVatRate(VatRate(value: 0.02)).build()
           let invoice = anInvoice()
               .withItems([item1, item2])
               .withSeller(CounterpartyBuilder().withCountry("Poland").build())
               .withBuyer(CounterpartyBuilder().withCountry("Denmark").build())
               .build()
           let classifiesForReverseCharge = invoice.mightMissReverseCharge()
           XCTAssertFalse(classifiesForReverseCharge)
       }
    
    func aCounterparty() -> Counterparty {
        return CounterpartyBuilder()
            .build()
    }
}
