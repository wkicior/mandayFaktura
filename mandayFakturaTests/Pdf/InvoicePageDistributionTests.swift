//
//  InvoicePageDistributionTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 08.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

import XCTest
@testable import mandayFaktura

class InvoicePageDistributionTests: XCTestCase {
    let INVOICE_NUMBER = "NI/44"
    
    func testDistributionOverPageCompositions_should_return_one_page_component_containing_minimal_invoice_with_no_items() {
        //given
        let invoice: Invoice = aMinimumInvoice().build()
        let distribution: InvoicePageDistribution = InvoicePageDistribution(copyTemplate: .original, invoice: invoice)
        
        //when
        let pageComponents: [InvoicePageComposition] = distribution.distributeDocumentOverPageCompositions() as! [InvoicePageComposition]
        
        //then
        XCTAssertEqual(1, pageComponents.count)
        XCTAssertEqual(3, pageComponents[0].headerComponents.count)
        XCTAssertEqual(2, pageComponents[0].counterpartyComponents.count)
        XCTAssertEqual(3, pageComponents[0].itemTableRowComponents.count)
        XCTAssertEqual(2, pageComponents[0].summaryComponents.count)
        XCTAssertTrue(pageComponents[0].pageNumberingComponent == nil)
 

    }
    
    func testDistributionOverPageCompositions_should_return_one_page_component_containing_invoice_with_items_and_notes() {
        //given
        let invoice: Invoice = aMinimumInvoice()
            .withItems([anInvoiceItem().build()])
            .withNotes("Knight who say Ni")
            .build()
        let distribution: InvoicePageDistribution = InvoicePageDistribution(copyTemplate: .original, invoice: invoice)
        
        //when
        let pageComponents: [InvoicePageComposition] = distribution.distributeDocumentOverPageCompositions() as! [InvoicePageComposition]
        
        //then
        XCTAssertEqual(1, pageComponents.count)
        XCTAssertEqual(4, pageComponents[0].itemTableRowComponents.count)
        XCTAssertEqual(2, pageComponents[0].summaryComponents.count)
        XCTAssertTrue(pageComponents[0].pageNumberingComponent == nil)

    }
    
    func testDistributionOverPageCompositions_should_return_two_page_component_containing_invoice_with_number_of_items_that_splits_the_page() {
        //given
        let invoice: Invoice = aMinimumInvoice()
            .withItems((0 ..< 27).map({i in anInvoiceItem().withName("a").build()}))
            .withNotes("Knight who say Ni")
            .build()
        let distribution: InvoicePageDistribution = InvoicePageDistribution(copyTemplate: .original, invoice: invoice)
        
        //when
        let pageComponents: [InvoicePageComposition] = distribution.distributeDocumentOverPageCompositions() as! [InvoicePageComposition]
        
        //then
        XCTAssertEqual(2, pageComponents.count)
        XCTAssertEqual(27, pageComponents[0].itemTableRowComponents.count) //header + 26 invoice items
        XCTAssertEqual(0, pageComponents[0].summaryComponents.count)
        XCTAssertTrue(pageComponents[0].pageNumberingComponent != nil)


        XCTAssertEqual(3, pageComponents[1].headerComponents.count)
        XCTAssertEqual(2, pageComponents[1].counterpartyComponents.count)
        XCTAssertEqual(4, pageComponents[1].itemTableRowComponents.count) //header + item + summary + 1 vat breakdown
        XCTAssertEqual(2, pageComponents[1].summaryComponents.count)
        XCTAssertTrue(pageComponents[0].pageNumberingComponent != nil)

    }
    
    func testDistributionOverPageCompositions_should_return_two_page_component_containing_invoice_with_number_of_items_that_vat_breakdown_splits_the_page() {
        //given
        let invoice: Invoice = aMinimumInvoice()
            .withItems((0 ..< 26).map({i in anInvoiceItem().withName("a").build()}))
            .withNotes("Knight who say Ni")
            .build()
        let distribution: InvoicePageDistribution = InvoicePageDistribution(copyTemplate: .original, invoice: invoice)
        
        //when
        let pageComponents: [InvoicePageComposition] = distribution.distributeDocumentOverPageCompositions() as! [InvoicePageComposition]
        
        //then
        XCTAssertEqual(2, pageComponents.count)
        XCTAssertEqual(27, pageComponents[0].itemTableRowComponents.count) //header + 24 invoice items
        XCTAssertEqual(0, pageComponents[0].summaryComponents.count)
        
        XCTAssertEqual(3, pageComponents[1].headerComponents.count)
        XCTAssertEqual(2, pageComponents[1].counterpartyComponents.count)
        XCTAssertEqual(2, pageComponents[1].itemTableRowComponents.count) //summary + 1 vat breakdown
        XCTAssertEqual(2, pageComponents[1].summaryComponents.count)
    }
    
    func testDistributionOverPageCompositions_should_return_two_page_component_containing_invoice_with_number_of_items_that_notes_splits_the_page() {
        //given
        let invoice: Invoice = aMinimumInvoice()
            .withItems((0 ..< 19).map({i in anInvoiceItem().withName("a").build()}))
            .withNotes("Knight who say Ni")
            .build()
        let distribution: InvoicePageDistribution = InvoicePageDistribution(copyTemplate: .original, invoice: invoice)
        
        //when
        let pageComponents: [InvoicePageComposition] = distribution.distributeDocumentOverPageCompositions() as! [InvoicePageComposition]
        
        //then
        XCTAssertEqual(2, pageComponents.count)
        XCTAssertEqual(22, pageComponents[0].itemTableRowComponents.count) //header + 19 invoice items + summary + vat breakdown
        XCTAssertEqual(1, pageComponents[0].summaryComponents.count) // payment summary
        
        XCTAssertEqual(3, pageComponents[1].headerComponents.count)
        XCTAssertEqual(2, pageComponents[1].counterpartyComponents.count)
        XCTAssertEqual(0, pageComponents[1].itemTableRowComponents.count)
        XCTAssertEqual(1, pageComponents[1].summaryComponents.count) //notes
    }
    
    func testDistributionOverPageCompositions_should_return_two_page_component_containing_invoice_with_number_of_items_that_payment_summary_splits_the_page() {
        //given
        let invoice: Invoice = aMinimumInvoice()
            .withItems((0 ..< 20).map({i in anInvoiceItem().withName("a").build()}))
            .withNotes("Knight who say Ni")
            .build()
        let distribution: InvoicePageDistribution = InvoicePageDistribution(copyTemplate: .original, invoice: invoice)
        
        //when
        let pageComponents: [InvoicePageComposition] = distribution.distributeDocumentOverPageCompositions() as! [InvoicePageComposition]
        
        //then
        XCTAssertEqual(2, pageComponents.count)
        XCTAssertEqual(23, pageComponents[0].itemTableRowComponents.count) //header + 24 invoice items
        XCTAssertEqual(0, pageComponents[0].summaryComponents.count)
        
        XCTAssertEqual(3, pageComponents[1].headerComponents.count)
        XCTAssertEqual(2, pageComponents[1].counterpartyComponents.count)
        XCTAssertEqual(0, pageComponents[1].itemTableRowComponents.count)
        XCTAssertEqual(2, pageComponents[1].summaryComponents.count)
    }
    
    func sampleCounterParty() -> Counterparty {
        return CounterpartyBuilder().build()
    }
    
    fileprivate func aMinimumInvoice() -> InvoiceBuilder {
        return anInvoice()
            .withBuyer(sampleCounterParty())
            .withSeller(sampleCounterParty())
            .withNumber(INVOICE_NUMBER)
            .withIssueDate(Date()).withSellingDate(Date())
    }
}
