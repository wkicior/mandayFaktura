//
//  InvoiceItem.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 01.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct InvoiceItem {
    let name: String
    let amount: Decimal
    let unitOfMeasure: UnitOfMeasure
    let unitNetPrice: Decimal
    let vatValueInPercent: Decimal
    
    var netValue: Decimal {
        get {
            var netValue = amount * unitNetPrice
            var result = Decimal()
            NSDecimalRound(&result, &netValue, 2, .plain)
            return result
        }
    }
    
    var grossValue: Decimal {
        get {
            var grossValue =  netValue * (vatValueInPercent/100 + 1)
            var result = Decimal()
            NSDecimalRound(&result, &grossValue, 2, .plain)
            return result
        }
    }
}
