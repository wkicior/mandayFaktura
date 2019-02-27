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
    let entries: [BreakdownEntry]
    
    init(entries: [BreakdownEntry]) {
        self.entries = entries
    }
    
    /**
     Returns summed values for each vat value
    */
    static func fromInvoiceItems(invoiceItems: [InvoiceItem]) -> VatBreakdown {
        let vatRates =  Array(Set<VatRate>(invoiceItems.map({i in i.vatRate}))).sorted {
            if (!$0.special && !$1.special) {
                return $0.value < $1.value
            }
            return $0.literal < $1.literal
        }
        let entries: [BreakdownEntry] = vatRates.map({ vat in
            let netValueSum = invoiceItems.filter({i in vat.literal == i.vatRate.literal}).map({i in i.netValue}).reduce(0, +)
            return BreakdownEntry(vatRate: vat, netValue: netValueSum)
        })
        return VatBreakdown(entries: entries)
        
    }
}

extension VatBreakdown {
    static func -(lhs: VatBreakdown, rhs: VatBreakdown) -> VatBreakdown {
        return lhs + -1 * rhs
    }
    
    static func +(lhs: VatBreakdown, rhs: VatBreakdown) -> VatBreakdown {
        let sum: [BreakdownEntry] = lhs.entries + rhs.entries
        let entries: [BreakdownEntry] = sum
            .reduce(into: [VatRate:Decimal](), {result, breakdownEntry in
                result[breakdownEntry.vatRate] = breakdownEntry.netValue + (result[breakdownEntry.vatRate] ?? 0)})
            .map({key, value in BreakdownEntry(vatRate: key, netValue: value)})
        return VatBreakdown(entries: entries)
    }
    
    static func *(lhs: Int, rhs: VatBreakdown) -> VatBreakdown {
        let entries: [BreakdownEntry] = rhs.entries.compactMap({x in BreakdownEntry(vatRate: x.vatRate, netValue: Decimal(lhs) * x.netValue)})
      
        return VatBreakdown(entries: entries)

    }
    
}
