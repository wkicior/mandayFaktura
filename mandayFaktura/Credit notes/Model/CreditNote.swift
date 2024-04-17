//
//  CreditNote.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 17.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

struct CreditNote: Document {
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
    let reverseCharge: Bool
    let primaryLanguage: Language
    let secondaryLanguage: Language?
    var ksefNumber: String?

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
            return VatBreakdown.fromInvoiceItems(invoiceItems:  self.items)
        }
    }
    
    func differenceNetValue(on: Invoice) -> Decimal {
        return totalNetValue - on.totalNetValue
    }
    
    func differenceVatValue(on: Invoice) -> Decimal {
        return totalVatValue - on.totalVatValue
    }
    
    func differenceGrossValue(on: Invoice) -> Decimal {
        return totalGrossValue - on.totalGrossValue
    }
    
    func differenceVatBreakdown(on: Invoice) -> VatBreakdown {
        return vatBreakdown - on.vatBreakdown
    }
    
    func isInternational() -> Bool {
        return self.seller.country != self.buyer.country && !self.buyer.country.isEmpty
    }
    
    var hasKsefNumber: Bool {
        get {
            return self.ksefNumber != nil && !self.ksefNumber!.isBlank
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
    private var reverseCharge = false
    private var primaryLanguage: Language = Language.PL
    private var secondaryLanguage: Language? = nil
    private var ksefNumber: String? = nil
    
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
    
    func withReverseCharge(_ reverseCharge: Bool) -> CreditNoteBuilder {
        self.reverseCharge = reverseCharge
        return self
    }
    
    func withPrimaryLanguage(_ primaryLanguage: Language) -> CreditNoteBuilder {
       self.primaryLanguage = primaryLanguage
       return self
   }
   
   func withSecondaryLanguage(_ secondaryLanguage: Language?) -> CreditNoteBuilder {
       self.secondaryLanguage = secondaryLanguage
       return self
   }
    
   func withKsefNumber(_ ksefNumber: String?) -> CreditNoteBuilder {
       self.ksefNumber = ksefNumber
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
                       invoiceNumber: invoiceNumber!,
                       reverseCharge: reverseCharge,
                       primaryLanguage: primaryLanguage,
                       secondaryLanguage: secondaryLanguage,
                       ksefNumber: ksefNumber
                          
        )
    }
}
