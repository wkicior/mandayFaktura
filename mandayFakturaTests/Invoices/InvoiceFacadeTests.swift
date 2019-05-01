//
//  InvoiceFacadeTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 01.05.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//


import Foundation
import XCTest
@testable import mandayFaktura

fileprivate class MockInvoiceRepository: InvoiceRepository {
    
    var invoices: [String: Invoice]
    
    init(invoices: [Invoice]) {
        self.invoices = invoices.reduce(into: [String: Invoice]()) {
            $0[$1.number] = $1
        }
    }
    
    func findBy(invoiceNumber: String) -> Invoice? {
        return self.invoices[invoiceNumber]
    }
    
    func getInvoice(number: String) -> Invoice {
        return self.invoices[number]!
    }
    
    func editInvoice(old: Invoice, new: Invoice) {
        self.invoices.removeValue(forKey: old.number)
        self.invoices[new.number] = new
    }
    
    func getLastInvoice() -> Invoice? {
        return nil
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

fileprivate class MockInvoiceNumbering: InvoiceNumbering {
    let throwError: Bool
    init(throwError: Bool = false) {
        self.throwError = throwError
    }
    override public func verifyInvoiceWithNumberDoesNotExist(invoiceNumber: String) throws {
        if (throwError) {
            throw InvoiceExistsError.invoiceNumber(number: invoiceNumber)
        }
    }
}

fileprivate class MockCreditNoteNumbering: CreditNoteNumbering {
    let throwError: Bool
    init(throwError: Bool = false) {
        self.throwError = throwError
    }
    override public func verifyCreditNoteWithNumberDoesNotExist(creditNoteNumber: String) throws {
        if (throwError) {
            throw InvoiceExistsError.invoiceNumber(number: creditNoteNumber)
        }
    }
}

class InvoiceFacadeTests: XCTestCase {
    
    func testEditInvoice_edit_invoice_for_new_number_that_does_not_exists_yet() {
        //given
        let oldInvoice = sampleInvoice()
            .withNumber("A/1")
            .build()
        let newInvoice = sampleInvoice()
            .withNumber("A/2").withNotes("some notes").build()
        let invoiceRepository: InvoiceRepository = MockInvoiceRepository(invoices: [oldInvoice])
        let invoiceNumbering: InvoiceNumbering = MockInvoiceNumbering()
        let creditNoteNumbering: CreditNoteNumbering = MockCreditNoteNumbering()
        let invoiceFacade = InvoiceFacade(invoiceRepository: invoiceRepository, invoiceNumbering: invoiceNumbering, creditNoteNumbering: creditNoteNumbering)
        
        //when
        try! invoiceFacade.editInvoice(old: oldInvoice, new: newInvoice)
        
        //then
        XCTAssertEqual("some notes",  invoiceRepository.findBy(invoiceNumber: newInvoice.number)!.notes, "Note value should have been updated")
    }
    
    func testEditInvoice_edit_invoice_for_old_number() {
        //given
        let oldInvoice = sampleInvoice()
            .withNumber("A/1")
            .build()
        let newInvoice = sampleInvoice()
            .withNumber("A/1").withNotes("some notes").build()
        let invoiceRepository: InvoiceRepository = MockInvoiceRepository(invoices: [oldInvoice])
        let invoiceNumbering: InvoiceNumbering = MockInvoiceNumbering(throwError: true)
        let creditNoteNumbering: CreditNoteNumbering = MockCreditNoteNumbering()
        let invoiceFacade = InvoiceFacade(invoiceRepository: invoiceRepository, invoiceNumbering: invoiceNumbering, creditNoteNumbering: creditNoteNumbering)
        
        //when
        try! invoiceFacade.editInvoice(old: oldInvoice, new: newInvoice)
        
        //then
        XCTAssertEqual("some notes",  invoiceRepository.findBy(invoiceNumber: newInvoice.number)!.notes, "Note value should have been updated")
    }
    
    func testEditInvoice_edit_invoice_for_new_number_that_does_exists_throws_error() {
        //given
        let oldInvoice = sampleInvoice()
            .withNumber("A/1")
            .build()
        let newInvoice = sampleInvoice()
            .withNumber("A/2").build()
        let invoiceRepository: InvoiceRepository = MockInvoiceRepository(invoices: [oldInvoice])
        let invoiceNumbering: InvoiceNumbering = MockInvoiceNumbering(throwError: true)
        let creditNoteNumbering: CreditNoteNumbering = MockCreditNoteNumbering()
        let invoiceFacade = InvoiceFacade(invoiceRepository: invoiceRepository, invoiceNumbering: invoiceNumbering, creditNoteNumbering: creditNoteNumbering)
        
        //when
        do {
            try invoiceFacade.editInvoice(old: oldInvoice, new: newInvoice)
        } catch InvoiceExistsError.invoiceNumber( _) {
            return
        } catch {
            //
        }
        //then
        XCTFail("exception should have been thrown")
    }
    
    func testEditInvoice_edit_invoice_for_new_number_that_does_exists_for_credit_note_throws_error() {
        //given
        let oldInvoice = sampleInvoice()
            .withNumber("A/1")
            .build()
        let newInvoice = sampleInvoice()
            .withNumber("A/2").build()
        let invoiceRepository: InvoiceRepository = MockInvoiceRepository(invoices: [oldInvoice])
        let invoiceNumbering: InvoiceNumbering = MockInvoiceNumbering()
        let creditNoteNumbering: CreditNoteNumbering = MockCreditNoteNumbering(throwError: true)
        let invoiceFacade = InvoiceFacade(invoiceRepository: invoiceRepository, invoiceNumbering: invoiceNumbering, creditNoteNumbering: creditNoteNumbering)
        
        //when
        do {
            try invoiceFacade.editInvoice(old: oldInvoice, new: newInvoice)
        } catch InvoiceExistsError.invoiceNumber( _) {
            return
        } catch {
            //
        }
        //then
        XCTFail("exception should have been thrown")
    }
    
    fileprivate func sampleInvoice() -> InvoiceBuilder {
        return anInvoice()
            .withItems([])
            .withSeller(aCounterparty().build())
            .withBuyer(aCounterparty().build())
    }
    
    fileprivate func anInvoice() -> InvoiceBuilder {
        return InvoiceBuilder()
    }
    
    fileprivate func aCounterparty() -> CounterpartyBuilder {
        return CounterpartyBuilder()
    }
}
