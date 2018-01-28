//
//  InvoicesRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 27.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InMemoryInvoicesRepository: InvoiceRepository {
    let invoices = [Invoice(issueDate: Date(), number: "01/A/2018"), Invoice(issueDate: Date(), number: "01/A/2018")]
    
    func getInvoices() -> [Invoice] {
        return invoices
    }
}
