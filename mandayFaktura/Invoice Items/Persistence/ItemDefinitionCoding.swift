//
//  ItemDefinitionCoding.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 26.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

@objc(ItemDefinitionCoding) class ItemDefinitionCoding: NSObject, NSCoding {
    let itemDefinition: ItemDefinition
    
    func encode(with coder: NSCoder) {
        coder.encode(self.itemDefinition.name, forKey: "name")
        coder.encode(self.itemDefinition.alias, forKey: "alias")
        coder.encode(self.itemDefinition.unitNetPrice, forKey: "unitNetPrice")
        coder.encode(self.itemDefinition.unitOfMeasure.rawValue, forKey: "unitOfMeasure")
        coder.encode(VatRateCoding(self.itemDefinition.vatRate), forKey: "vatRate")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: "name") as? String,
            let alias = decoder.decodeObject(forKey: "alias") as? String,
            let unitNetPrice = decoder.decodeObject(forKey: "unitNetPrice") as? Decimal
        
            else { return nil }
        let unitOfMeasure = UnitOfMeasure(rawValue: (decoder.decodeInteger(forKey: "unitOfMeasure")))!
        //vatRateInPercent - is deprecated
        let vatRateInPercent: Decimal? = decoder.decodeObject(forKey: "vatRateInPercent") as? Decimal
        let vatRateCoding = decoder.decodeObject(forKey: "vatRate") as? VatRateCoding
        let vatRate = vatRateCoding?.vatRate
        self.init(anItemDefinition()
            .withName(name)
            .withAlias(alias)
            .withUnitNetPrice(unitNetPrice)
            .withUnitOfMeasure(unitOfMeasure)
            .withVatRate(vatRate ?? VatRate(value: vatRateInPercent! / 100))
            .build())
    }
    
    init(_ itemDefinition: ItemDefinition) {
        self.itemDefinition = itemDefinition
    }
    
}
