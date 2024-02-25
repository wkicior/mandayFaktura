//
//  InvoiceFacade.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 22.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InvoiceFacade {
    private let invoiceRepository: InvoiceRepository
    private let invoiceNumbering: InvoiceNumbering
    private let creditNoteNumbering: CreditNoteNumbering
    
    init(invoiceRepository: InvoiceRepository = InvoiceRepositoryFactory.instance,
         invoiceNumbering: InvoiceNumbering = InvoiceNumbering(),
         creditNoteNumbering: CreditNoteNumbering = CreditNoteNumbering()) {
        self.invoiceRepository = invoiceRepository
        self.invoiceNumbering = invoiceNumbering
        self.creditNoteNumbering = creditNoteNumbering
    }
    
    func getInvoices() -> [Invoice] {
        return invoiceRepository.getInvoices()
    
    }
    
    func getInvoice(number: String) -> Invoice {
        return invoiceRepository.getInvoice(number: number)
    }
    
    func delete(_ invoice: Invoice) {
        invoiceRepository.delete(invoice)
    }
    
    func addInvoice(_ invoice: Invoice) throws {
        try invoiceNumbering.verifyInvoiceWithNumberDoesNotExist(invoiceNumber: invoice.number)
        try creditNoteNumbering.verifyCreditNoteWithNumberDoesNotExist(creditNoteNumber: invoice.number)
        invoiceRepository.addInvoice(invoice)
    }
    
    func editInvoice(old: Invoice, new: Invoice) throws {
        if (!old.sameInvoiceNumberAs(invoice: new)) {
            try invoiceNumbering.verifyInvoiceWithNumberDoesNotExist(invoiceNumber: new.number)
            try creditNoteNumbering.verifyCreditNoteWithNumberDoesNotExist(creditNoteNumber: new.number)
        }
        invoiceRepository.editInvoice(old: old, new: new)
    }
}
