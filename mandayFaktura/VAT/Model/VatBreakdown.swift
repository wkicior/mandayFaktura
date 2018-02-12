//
//  VatBreakdown.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct BreakdownEntry: Equatable {
    let vatValueInPercent: Decimal
    let netValue: Decimal
    
    var grossValue: Decimal {
        get {
            return netValue + vatValue
        }
    }
    
    var vatValue: Decimal {
        get {
            var vatValue = vatValueInPercent/100 * netValue
            var result = Decimal()
            NSDecimalRound(&result, &vatValue, 2, .plain)
            return result
        }
    }
    
    static func == (lhs: BreakdownEntry, rhs: BreakdownEntry) -> Bool {
        return
            lhs.vatValueInPercent == rhs.vatValueInPercent &&
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
            let vatValues = Array(Set(invoiceItems.map({i in i.vatValueInPercent}))).sorted()
            return vatValues.map({ vat in
                let netValueSum = invoiceItems.filter({i in vat == i.vatValueInPercent}).map({i in i.netValue}).reduce(0, +)
                return BreakdownEntry(vatValueInPercent: vat, netValue: netValueSum)
            })
        }
    }
}
