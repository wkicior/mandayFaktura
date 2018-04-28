//
//  ItemDefinition.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct ItemDefinition {
    let name: String
    let alias: String
    let unitOfMeasure: UnitOfMeasure
    let unitNetPrice: Decimal
    let vatRate: VatRate
}
func anItemDefinition() -> ItemDefinitionBuilder {
    return ItemDefinitionBuilder()
}
class ItemDefinitionBuilder {
    var name = ""
    var alias = ""
    var unitOfMeasure: UnitOfMeasure = .pieces
    var unitNetPrice = Decimal()
    var vatRate = VatRate(value: Decimal(), literal: "0%")
    
    func from(source: ItemDefinition) -> ItemDefinitionBuilder {
        self.name = source.name
        self.alias = source.alias
        self.unitOfMeasure = source.unitOfMeasure
        self.unitNetPrice = source.unitNetPrice
        self.vatRate = source.vatRate
        return self
    }
    
    func from(item: InvoiceItem) -> ItemDefinitionBuilder {
        self.name = item.name
        self.alias = item.name
        self.unitOfMeasure = item.unitOfMeasure
        self.unitNetPrice = item.unitNetPrice
        self.vatRate = item.vatRate
        return self
    }
    
    func build() -> ItemDefinition {
        return ItemDefinition(name: name, alias: alias, unitOfMeasure: unitOfMeasure, unitNetPrice: unitNetPrice, vatRate: vatRate)
    }
    
    func withName(_ name: String) -> ItemDefinitionBuilder {
        self.name = name
        return self
    }
    
    func withAlias(_ alias: String) -> ItemDefinitionBuilder {
        self.alias = alias
        return self
    }
    
    func withUnitOfMeasure(_ unitOfMeasure: UnitOfMeasure) -> ItemDefinitionBuilder {
        self.unitOfMeasure = unitOfMeasure
        return self
    }
    
    func withUnitNetPrice(_ unitNetPrice: Decimal) -> ItemDefinitionBuilder {
        self.unitNetPrice = unitNetPrice
        return self
    }
    
    func withVatRate(_ vatRate: VatRate) -> ItemDefinitionBuilder {
        self.vatRate = vatRate
        return self
    }
    
    
}
