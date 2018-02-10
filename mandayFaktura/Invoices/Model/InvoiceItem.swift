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
}

func anInvoiceItem()-> InvoiceItemBuilder {
    return InvoiceItemBuilder()
}

class InvoiceItemBuilder {
    private var name = ""
    private var amount = Decimal()
    private var unitOfMeasure: UnitOfMeasure?
    private var unitNetPrice = Decimal()
    private var vatValueInPercent = Decimal()
    
    
    func from(source: InvoiceItem) -> InvoiceItemBuilder {
        self.name = source.name
        self.amount = source.amount
        self.unitOfMeasure = source.unitOfMeasure
        self.unitNetPrice = source.unitNetPrice
        self.vatValueInPercent = source.vatValueInPercent
        return self
    }
    
    func withName(_ name: String) -> InvoiceItemBuilder {
        self.name = name;
        return self
    }
    
    func withUnitNetPrice(_ unitNetPrice: Decimal) -> InvoiceItemBuilder {
        self.unitNetPrice = unitNetPrice
        return self
    }
    
    func withUnitOfMeasure(_ unitOfMeasure: UnitOfMeasure) -> InvoiceItemBuilder {
        self.unitOfMeasure = unitOfMeasure
        return self
    }
    
    func build()->InvoiceItem {
        return InvoiceItem(name: name, amount: amount, unitOfMeasure: unitOfMeasure!, unitNetPrice: unitNetPrice, vatValueInPercent: vatValueInPercent)
    }
}
