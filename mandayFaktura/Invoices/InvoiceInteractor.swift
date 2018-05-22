//
//  InvoiceInteractor.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 22.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InvoiceInteractor {
    let invoiceRepository: InvoiceRepository = InvoiceRepositoryFactory.instance
    
    func getInvoices() -> [Invoice] {
        return invoiceRepository.getInvoices()
    }
    
    func delete(_ invoice: Invoice) {
        invoiceRepository.delete(invoice)
    }
    
    func addInvoice(_ invoice: Invoice) throws {
        try invoiceRepository.addInvoice(invoice)
    }
    
    func editInvoice(old: Invoice, new: Invoice) {
        invoiceRepository.editInvoice(old: old, new: new)
    }
}
