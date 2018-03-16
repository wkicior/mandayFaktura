//
//  KeyedArchiverInvoiceRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 17.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

@objc(InvoiceCoding)private class InvoiceCoding: NSObject, NSCoding {
    let invoice: Invoice
    
    func encode(with coder: NSCoder) {
        coder.encode(self.invoice.issueDate, forKey: "issueDate")
        coder.encode(self.invoice.number, forKey: "number")
        coder.encode(self.invoice.sellingDate, forKey: "sellingDate")
        coder.encode(CounterpartyCoding(self.invoice.seller), forKey: "seller")
        coder.encode(CounterpartyCoding(self.invoice.buyer), forKey: "buyer")
        coder.encode(self.invoice.items.map{i in InvoiceItemCoding(i)}, forKey: "items")
        coder.encode(self.invoice.paymentForm.rawValue, forKey: "paymentForm")
        coder.encode(self.invoice.paymentDueDate, forKey: "paymentDueDate")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let number = decoder.decodeObject(forKey: "number") as? String,
            let issueDate = decoder.decodeObject(forKey: "issueDate") as? Date,
            let sellingDate = decoder.decodeObject(forKey: "sellingDate") as? Date,
            let seller = (decoder.decodeObject(forKey: "seller") as? CounterpartyCoding)?.counterparty,
            let buyer = (decoder.decodeObject(forKey: "buyer") as? CounterpartyCoding)?.counterparty,
            let itemsCoding = decoder.decodeObject(forKey: "items") as? [InvoiceItemCoding],
            let paymentDueDate = decoder.decodeObject(forKey: "paymentDueDate") as? Date
            else { return nil }
        let items = itemsCoding.map({c in c.invoiceItem})
        let paymentForm = PaymentForm(rawValue: decoder.decodeInteger(forKey: "paymentForm"))!

        self.init(anInvoice()
            .withIssueDate(issueDate)
            .withNumber(number)
            .withSellingDate(sellingDate)
            .withSeller(seller)
            .withBuyer(buyer)
            .withItems(items)
            .withPaymentForm(paymentForm)
            .withPaymentDueDate(paymentDueDate)
            .build())
    }
    
    init(_ invoice: Invoice) {
        self.invoice = invoice
    }
}

class KeyedArchiverInvoiceRepository: InvoiceRepository {
    private let key = "invoices" + AppDelegate.keyedArchiverProfile
    func getInvoices() -> [Invoice] {
        return invoicesCoding.map{ic in ic.invoice}
    }
    
    func addInvoice(_ invoice: Invoice) {
        invoicesCoding.append(InvoiceCoding(invoice))
    }
    
    func delete(_ invoice: Invoice) {
        let index = invoicesCoding.index(where: {ic in ic.invoice.number == invoice.number})
        invoicesCoding.remove(at: index!)
    }
    
    func getLastInvoice() -> Invoice? {
        return invoicesCoding.last.map({ic in ic.invoice})
    }
    
    private var invoicesCoding: [InvoiceCoding] {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? NSData {
                return  NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [InvoiceCoding]
            }
            return []
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
