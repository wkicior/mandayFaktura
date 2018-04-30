//
//  VatBreakdown.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct BreakdownEntry: Equatable {
    let vatRate: VatRate
    let netValue: Decimal
    
    var grossValue: Decimal {
        get {
            return netValue + vatValue
        }
    }
    
    var vatValue: Decimal {
        get {
            var vatValue = vatRate.value * netValue
            var result = Decimal()
            NSDecimalRound(&result, &vatValue, 2, .plain)
            return result
        }
    }
    
    static func == (lhs: BreakdownEntry, rhs: BreakdownEntry) -> Bool {
        return
            lhs.vatRate.literal == rhs.vatRate.literal &&
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
            let vatRates =  Array(Set<VatRate>(invoiceItems.map({i in i.vatRate}))).sorted {
                if (!$0.special && !$1.special) {
                    return $0.value < $1.value
                }
                return $0.literal < $1.literal
            }
            return vatRates.map({ vat in
                let netValueSum = invoiceItems.filter({i in vat.literal == i.vatRate.literal}).map({i in i.netValue}).reduce(0, +)
                return BreakdownEntry(vatRate: vat, netValue: netValueSum)
            })
        }
    }
}
