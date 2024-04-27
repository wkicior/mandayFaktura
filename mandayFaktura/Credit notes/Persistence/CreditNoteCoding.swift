//
//  CreditNoteCoding.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 23.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

@objc(creditNoteCoding) class CreditNoteCoding: NSObject, NSCoding {
    let creditNote: CreditNote
    
    func encode(with coder: NSCoder) {
        coder.encode(self.creditNote.issueDate, forKey: "issueDate")
        coder.encode(self.creditNote.number, forKey: "number")
        coder.encode(self.creditNote.sellingDate, forKey: "sellingDate")
        coder.encode(CounterpartyCoding(self.creditNote.seller), forKey: "seller")
        coder.encode(CounterpartyCoding(self.creditNote.buyer), forKey: "buyer")
        coder.encode(self.creditNote.items.map{i in InvoiceItemCoding(i)}, forKey: "items")
        coder.encode(self.creditNote.paymentForm.rawValue, forKey: "paymentForm")
        coder.encode(self.creditNote.paymentDueDate, forKey: "paymentDueDate")
        coder.encode(self.creditNote.reason, forKey: "reason")
        coder.encode(self.creditNote.invoiceNumber, forKey: "invoiceNumber")
        coder.encode(self.creditNote.reverseCharge, forKey: "reverseCharge")
        coder.encode(self.creditNote.primaryLanguage.rawValue, forKey: "primaryLanguage")
        coder.encode(self.creditNote.secondaryLanguage?.rawValue ?? nil, forKey: "secondaryLanguage")
        coder.encode(self.creditNote.ksefNumber?.stringValue, forKey: "ksefNumber")
        coder.encode(self.creditNote.currency.rawValue, forKey: "currency")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let number = decoder.decodeObject(forKey: "number") as? String,
            let issueDate = decoder.decodeObject(forKey: "issueDate") as? Date,
            let sellingDate = decoder.decodeObject(forKey: "sellingDate") as? Date,
            let seller = (decoder.decodeObject(forKey: "seller") as? CounterpartyCoding)?.counterparty,
            let buyer = (decoder.decodeObject(forKey: "buyer") as? CounterpartyCoding)?.counterparty,
            let itemsCoding = decoder.decodeObject(forKey: "items") as? [InvoiceItemCoding],
            let paymentDueDate = decoder.decodeObject(forKey: "paymentDueDate") as? Date,
            let invoiceNumber = decoder.decodeObject(forKey: "invoiceNumber") as? String

            else { return nil }
        let reason = decoder.decodeObject(forKey: "reason") as? String
        let items = itemsCoding.map({c in c.invoiceItem})
        let paymentForm = PaymentForm(rawValue: decoder.decodeInteger(forKey: "paymentForm"))!
        let reverseCharge = decoder.decodeBool(forKey: "reverseCharge")
        let currencyCode = decoder.decodeObject(forKey: "currency") as? String
        
        var primaryLanguageCode = decoder.decodeObject(forKey: "primaryLanguage") as? String
               var secondaryLanguageCode = decoder.decodeObject(forKey: "secondaryLanguage") as? String
               
               if (primaryLanguageCode == nil && seller.country != buyer.country && !buyer.country.isEmpty) {
                   primaryLanguageCode = Language.EN.rawValue
                   secondaryLanguageCode = Language.PL.rawValue
               } else if (primaryLanguageCode == nil) {
                   primaryLanguageCode = Language.PL.rawValue
               }
        let ksefNumberString = decoder.decodeObject(forKey: "ksefNumber") as? String
        let ksefNumber: KsefNumber? =  ksefNumberString.flatMap { try? KsefNumber($0) }
        let currency = currencyCode.flatMap() { Currency(rawValue: $0) } ?? Currency.PLN
        
        self.init(aCreditNote()
            .withIssueDate(issueDate)
            .withNumber(number)
            .withSellingDate(sellingDate)
            .withSeller(seller)
            .withBuyer(buyer)
            .withItems(items)
            .withPaymentForm(paymentForm)
            .withPaymentDueDate(paymentDueDate)
            .withReason(reason ?? "")
            .withInvoiceNumber(invoiceNumber)
            .withReverseCharge(reverseCharge)
            .withPrimaryLanguage(Language(rawValue: primaryLanguageCode!)!)
            .withSecondaryLanguage(secondaryLanguageCode.map({Language(rawValue: $0)!}) ?? nil)
            .withKsefNumber(ksefNumber ?? nil)
            .withCurrency(currency)
            .build())
    }
    
    init(_ creditNote: CreditNote) {
        self.creditNote = creditNote
    }
}
