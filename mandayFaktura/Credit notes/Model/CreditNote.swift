//
//  CreditNote.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 17.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

struct CreditNote {
    let issueDate: Date
    let number: String
    let sellingDate: Date
    let seller: Counterparty
    let buyer: Counterparty
    let items: [InvoiceItem]
    let paymentForm: PaymentForm
    let paymentDueDate: Date
    let reason: String
    let invoiceNumber: String

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
    private var issueDate = Date()
    private var sellingDate = Date()
    private var seller: Counterparty?
    private var buyer: Counterparty?
    private var items: [InvoiceItem] = []
    private var paymentForm: PaymentForm = .transfer
    private var paymentDueDate = Date()
    private var reason = ""
    private var invoiceNumber: String?
    
    func withNumber(_ number: String) -> CreditNoteBuilder {
        self.number = number
        return self
    }
    
    func withIssueDate(_ issueDate: Date) -> CreditNoteBuilder {
        self.issueDate = issueDate
        return self
    }
   
    
    func withSellingDate(_ sellingDate: Date) -> CreditNoteBuilder {
        self.sellingDate = sellingDate
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
    
    func withReason(_ reason: String) -> CreditNoteBuilder {
        self.reason = reason
        return self
    }
    
    func withInvoiceNumber(_ invoiceNumber: String) -> CreditNoteBuilder {
        self.invoiceNumber = invoiceNumber
        return self
    }
    
    
    func build() -> CreditNote {
        return CreditNote(issueDate: issueDate,
                       number: number,
                       sellingDate: sellingDate,
                       seller: seller!,
                       buyer: buyer!,
                       items: items,
                       paymentForm: paymentForm,
                       paymentDueDate: paymentDueDate,
                       reason: reason,
                       invoiceNumber: invoiceNumber!
        )
    }
}
