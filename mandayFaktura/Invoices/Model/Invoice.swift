//
//  Invoice.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 27.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct Invoice {
    let issueDate: Date
    let number: String
    let sellingDate: Date
    let seller: Counterparty
    let buyer: Counterparty
    let items: [InvoiceItem]
    let paymentForm: PaymentForm
    let paymentDueDate: Date
    
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
}
