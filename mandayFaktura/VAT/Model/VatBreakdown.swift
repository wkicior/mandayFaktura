//
//  VatBreakdown.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct BreakdownEntry: Equatable {
    let vatRateInPercent: Decimal
    let netValue: Decimal
    
    var grossValue: Decimal {
        get {
            return netValue + vatValue
        }
    }
    
    var vatValue: Decimal {
        get {
            var vatValue = vatRateInPercent/100 * netValue
            var result = Decimal()
            NSDecimalRound(&result, &vatValue, 2, .plain)
            return result
        }
    }
    
    static func == (lhs: BreakdownEntry, rhs: BreakdownEntry) -> Bool {
        return
            lhs.vatRateInPercent == rhs.vatRateInPercent &&
                lhs.netValue == rhs.netValue
    }
}

/**
 Breaks down invoice item values for each vat value
 */
struct VatBreakdown {
    let invoiceItems: [InvoiceItem]
    
    init(invoiceItems: [InvoiceItem]) {
        self.invoiceItems = invoiceItems
    }
    
    /**
     Returns summed values for each vat value
    */
    var entries: [BreakdownEntry] {
        get {
            let vatValues = Array(Set(invoiceItems.map({i in i.vatRateInPercent}))).sorted()
            return vatValues.map({ vat in
                let netValueSum = invoiceItems.filter({i in vat == i.vatRateInPercent}).map({i in i.netValue}).reduce(0, +)
                return BreakdownEntry(vatRateInPercent: vat, netValue: netValueSum)
            })
        }
    }
}
