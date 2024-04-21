//
//  Invoice.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 27.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct Invoice: Document {
    let issueDate: Date
    let number: String
    let sellingDate: Date
    let seller: Counterparty
    let buyer: Counterparty
    let items: [InvoiceItem]
    let paymentForm: PaymentForm
    let paymentDueDate: Date
    let notes: String
    let reverseCharge: Bool
    let primaryLanguage: Language
    let secondaryLanguage: Language?
    var ksefNumber: KsefNumber?
    
    var totalNetValue: Decimal {
        get {
            return items.map{i in i.netValue}.reduce(0, +)
        }
    }
    
    func totalNetValue(forVatRates: [VatRate]) -> Decimal {
        return items
            .filter({s in forVatRates.contains(s.vatRate)})
            .map{i in i.netValue}
            .reduce(0, +)
    }
    
    var totalVatValue: Decimal {
        get {
            return items.map{i in i.vatValue}.reduce(0, +)
        }
    }
    
    func totalVatValue(forVatRates: [VatRate]) -> Decimal {
        return items
            .filter({s in forVatRates.contains(s.vatRate)})
            .map{i in i.vatValue}
            .reduce(0, +)
    }
    
    var totalGrossValue: Decimal {
        get {
            return items.map{i in i.grossValue}.reduce(0, +)
        }
    }
    
    var vatBreakdown: VatBreakdown {
        get {
            return VatBreakdown.fromInvoiceItems(invoiceItems: self.items)
        }
    }
    
    func isInternational() -> Bool {
        return self.seller.country != self.buyer.country && !self.buyer.country.isEmpty
    }
    
    func mightMissReverseCharge() -> Bool {
        return self.isInternational() && !self.reverseCharge && self.hasInvoiceItemsWith0VAT()
    }
    
    var hasKsefNumber: Bool {
        get {
            return self.ksefNumber != nil
        }
    }
    
    private func hasInvoiceItemsWith0VAT() -> Bool {
        self.items.map{i in i.vatValue}.filter{v in v == 0}.count > 0
    }
}


extension Invoice {
    func sameInvoiceNumberAs(invoice: Invoice) -> Bool {
        return number == invoice.number
    }
}

func anInvoice() -> InvoiceBuilder {
    return InvoiceBuilder()
}

class InvoiceBuilder {
    private var issueDate = Date()
    private var number = ""
    private var sellingDate = Date()
    private var seller: Counterparty?
    private var buyer: Counterparty?
    private var items: [InvoiceItem] = []
    private var paymentForm: PaymentForm = .transfer
    private var paymentDueDate = Date()
    private var notes = ""
    private var reverseCharge = false
    private var primaryLanguage: Language = Language.PL
    private var secondaryLanguage: Language? = nil
    private var ksefNumber: KsefNumber? = nil
    
    func withIssueDate(_ issueDate: Date) -> InvoiceBuilder {
        self.issueDate = issueDate
        return self
    }
    
    func withNumber(_ number: String) -> InvoiceBuilder {
        self.number = number
        return self
    }
    
    func withSellingDate(_ sellingDate: Date) -> InvoiceBuilder {
        self.sellingDate = sellingDate
        return self
    }
    
    func withSeller(_ seller: Counterparty) -> InvoiceBuilder {
        self.seller = seller
        return self
    }
    
    func withBuyer(_ buyer: Counterparty) -> InvoiceBuilder {
        self.buyer = buyer
        return self
    }
    
    func withItems(_ items: [InvoiceItem]) -> InvoiceBuilder {
        self.items = items
        return self
    }
    
    func withPaymentForm(_ paymentForm: PaymentForm) -> InvoiceBuilder {
        self.paymentForm = paymentForm
        return self
    }
    
    func withPaymentDueDate(_ paymentDueDate: Date) -> InvoiceBuilder {
        self.paymentDueDate = paymentDueDate
        return self
    }
    
    func withNotes(_ notes: String) -> InvoiceBuilder {
        self.notes = notes
        return self
    }
    
    func withReverseCharge(_ reverseCharge: Bool) -> InvoiceBuilder {
        self.reverseCharge = reverseCharge
        return self
    }
    
    func withPrimaryLanguage(_ primaryLanguage: Language) -> InvoiceBuilder {
        self.primaryLanguage = primaryLanguage
        return self
    }
    
    func withSecondaryLanguage(_ secondaryLanguage: Language?) -> InvoiceBuilder {
        self.secondaryLanguage = secondaryLanguage
        return self
    }
    
    func withKsefNumber(_ ksefNumber: KsefNumber?) -> InvoiceBuilder {
        self.ksefNumber = ksefNumber
        return self
    }
    
    func build() -> Invoice {
        return Invoice(issueDate: issueDate,
                       number: number,
                       sellingDate: sellingDate,
                       seller: seller!,
                       buyer: buyer!,
                       items: items,
                       paymentForm: paymentForm,
                       paymentDueDate: paymentDueDate,
                       notes: notes,
                       reverseCharge: reverseCharge,
                       primaryLanguage: primaryLanguage,
                       secondaryLanguage: secondaryLanguage,
                       ksefNumber: ksefNumber
        )
    }
}
