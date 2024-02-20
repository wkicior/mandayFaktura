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
    
    func testTotalNetValue_forVatRates() {
        let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(100).withVatRate(VatRate(string: "23%")).build()
        let item2 = anInvoiceItem().withAmount(1).withUnitNetPrice(200).build()
        let item3 = anInvoiceItem().withAmount(1).withUnitNetPrice(300).withVatRate(VatRate(string: "23%")).build()
        let item4 = anInvoiceItem().withAmount(1).withUnitNetPrice(400).withVatRate(VatRate(string: "22%")).build()
        let item5 = anInvoiceItem().withAmount(1).withUnitNetPrice(500).withVatRate(VatRate(string: "NP")).build()
        let invoice = anInvoice()
            .withSeller(aCounterparty())
            .withBuyer(aCounterparty())
            .withItems([item1, item2, item3, item4, item5])
            .build()
        
        XCTAssertEqual(400, invoice.totalNetValue(forVatRates: [VatRate(string: "23%")]))
        XCTAssertEqual(800, invoice.totalNetValue(forVatRates: [VatRate(string: "23%"), VatRate(string: "22%")]))
        XCTAssertEqual(500, invoice.totalNetValue(forVatRates: [VatRate(string: "NP")]))
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
    
    func testTotalVatValue_forVatRates() {
        let item1 = anInvoiceItem().withAmount(1).withUnitNetPrice(100).withVatRate(VatRate(string: "23%")).build()
        let item2 = anInvoiceItem().withAmount(1).withUnitNetPrice(200).build()
        let item3 = anInvoiceItem().withAmount(1).withUnitNetPrice(300).withVatRate(VatRate(string: "23%")).build()
        let item4 = anInvoiceItem().withAmount(1).withUnitNetPrice(400).withVatRate(VatRate(string: "22%")).build()
        let item5 = anInvoiceItem().withAmount(1).withUnitNetPrice(500).withVatRate(VatRate(string: "NP")).build()
        let invoice = anInvoice()
            .withSeller(aCounterparty())
            .withBuyer(aCounterparty())
            .withItems([item1, item2, item3, item4, item5])
            .build()
        
        XCTAssertEqual(92, invoice.totalVatValue(forVatRates: [VatRate(string: "23%")]))
        XCTAssertEqual(180, invoice.totalVatValue(forVatRates: [VatRate(string: "23%"), VatRate(string: "22%")]))
        XCTAssertEqual(0, invoice.totalVatValue(forVatRates: [VatRate(string: "NP")]))
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
