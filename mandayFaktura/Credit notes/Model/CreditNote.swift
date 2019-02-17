//
//  CreditNote.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 17.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

struct CreditNote {
    let number: String
    let invoiceNumber: String
    let invoiceIssueDate: Date
    let creditNoteIssueDate: Date
    let seller: Counterparty
    let buyer: Counterparty
    let items: [InvoiceItem]
    let paymentForm: PaymentForm
    let paymentDueDate: Date
    let notes: String

    
    var totalNetValue: Decimal {
        get {
            return items.map{i in i.netValue}.reduce(0, +)
        }
    }
    
    var totalVatValue: Decimal {
        get {
            return items.map{i in i.vatValue}.reduce(0, +)
        }
    }
    
    var totalGrossValue: Decimal {
        get {
            return items.map{i in i.grossValue}.reduce(0, +)
        }
    }
    
    var vatBreakdown: VatBreakdown {
        get {
            return VatBreakdown(invoiceItems: self.items)
        }
    }
}


func aCreditNote() -> CreditNoteBuilder {
    return CreditNoteBuilder()
}

class CreditNoteBuilder {
    private var number = ""
    private var invoiceNumber = ""
    private var invoiceIssueDate = Date()
    private var creditNoteIssueDate = Date()
    private var seller: Counterparty?
    private var buyer: Counterparty?
    private var items: [InvoiceItem] = []
    private var paymentForm: PaymentForm = .transfer
    private var paymentDueDate = Date()
    private var notes = ""
    
    func withNumber(_ number: String) -> CreditNoteBuilder {
        self.number = number
        return self
    }
    
    func withInvoiceNumber(_ number: String) -> CreditNoteBuilder {
        self.invoiceNumber = number
        return self
    }
    
    func withInvoiceIssueDate(_ issueDate: Date) -> CreditNoteBuilder {
        self.invoiceIssueDate = issueDate
        return self
    }
   
    
    func withCreditNoteIssueDate(_ creditNoteIssueDate: Date) -> CreditNoteBuilder {
        self.creditNoteIssueDate = creditNoteIssueDate
        return self
    }
    
    func withSeller(_ seller: Counterparty) -> CreditNoteBuilder {
        self.seller = seller
        return self
    }
    
    func withBuyer(_ buyer: Counterparty) -> CreditNoteBuilder {
        self.buyer = buyer
        return self
    }
    
    func withItems(_ items: [InvoiceItem]) -> CreditNoteBuilder {
        self.items = items
        return self
    }
    
    func withPaymentForm(_ paymentForm: PaymentForm) -> CreditNoteBuilder {
        self.paymentForm = paymentForm
        return self
    }
    
    func withPaymentDueDate(_ paymentDueDate: Date) -> CreditNoteBuilder {
        self.paymentDueDate = paymentDueDate
        return self
    }
    
    func withNotes(_ notes: String) -> CreditNoteBuilder {
        self.notes = notes
        return self
    }
    
    
    func build() -> CreditNote {
        return CreditNote(number: number,
                       invoiceNumber: invoiceNumber,
                       invoiceIssueDate: invoiceIssueDate,
                       creditNoteIssueDate: creditNoteIssueDate,
                       seller: seller!,
                       buyer: buyer!,
                       items: items,
                       paymentForm: paymentForm,
                       paymentDueDate: paymentDueDate,
                       notes: notes
        )
    }
}
