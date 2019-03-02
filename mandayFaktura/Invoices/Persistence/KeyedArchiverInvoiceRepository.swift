//
//  KeyedArchiverInvoiceRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 17.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class KeyedArchiverInvoiceRepository: InvoiceRepository {
    private let key = "invoices" + AppDelegate.keyedArchiverProfile
    func getInvoices() -> [Invoice] {
        return invoicesCoding.map{ic in ic.invoice}
    }
    
    public func findBy(invoiceNumber: String) -> Invoice? {
        return getInvoices().first(where: {i in i.number == invoiceNumber})
    }
    
    func addInvoice(_ invoice: Invoice) throws {
        if (findBy(invoiceNumber: invoice.number) != nil) {
            throw InvoiceExistsError.invoiceNumber(number: invoice.number)
        }
        invoicesCoding.append(InvoiceCoding(invoice))
    }
    
    func getInvoice(number: String) -> Invoice {
        return getInvoices().first(where: {i in i.number == number})!
    }
    
    func delete(_ invoice: Invoice) {
        let index = invoicesCoding.index(where: {ic in ic.invoice.number == invoice.number})
        invoicesCoding.remove(at: index!)
    }
    
    func getLastInvoice() -> Invoice? {
        return invoicesCoding.last.map({ic in ic.invoice})
    }
    
    func editInvoice(old: Invoice, new: Invoice) throws {
        if (findBy(invoiceNumber: new.number) != nil) {
            throw InvoiceExistsError.invoiceNumber(number: new.number)
        }
        let index = invoicesCoding.index(where: {ic in ic.invoice.number == old.number})
        invoicesCoding[index!] = InvoiceCoding(new)
    }
    
    private var invoicesCoding: [InvoiceCoding] {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? NSData {
                return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [InvoiceCoding]
            }
            return []
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
