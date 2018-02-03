//
//  InvoicesRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 27.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InMemoryInvoicesRepository: InvoiceRepository {
    var invoices: [Invoice]
    
    init() {
        let seller = Counterparty(name: "Firma Krzak", streetAndNumber: "Bolesława 4/12", city: "Warszawka", postalCode: "00-000", taxCode: "123456789", accountNumber:"PL0000111122223333")
        let buyer = Counterparty(name: "Firma XYZ", streetAndNumber: "Miłosza 4/12", city: "Szczebocin", postalCode: "00-000", taxCode: "123456789", accountNumber:"")
        self.invoices = [Invoice(issueDate: Date(), number: "01/A/2018", sellingDate: Date(), seller: seller, buyer: buyer, items: []),
                         Invoice(issueDate: Date(), number: "02/A/2018", sellingDate: Date(), seller: seller, buyer: buyer, items: []),
                         Invoice(issueDate: Date(), number: "03/A/2018", sellingDate: Date(), seller: seller, buyer: buyer, items: [])]
    }
   
    
    func getInvoices() -> [Invoice] {
        return invoices
    }
    
    func addInvoice(_ invoice:Invoice) {
        invoices.append(invoice)
    }
}
