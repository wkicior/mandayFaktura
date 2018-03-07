//
//  KeyArchiverItemDefinitionRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 07.03.2018.
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
        coder.encode(self.itemDefinition.vatRateInPercent, forKey: "vatRateInPercent")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: "name") as? String,
            let alias = decoder.decodeObject(forKey: "alias") as? String,
            let unitNetPrice = decoder.decodeObject(forKey: "unitNetPrice") as? Decimal,
            let vatRateInPercent = decoder.decodeObject(forKey: "vatRateInPercent") as? Decimal
            else { return nil }
        let unitOfMeasure = UnitOfMeasure(rawValue: (decoder.decodeInteger(forKey: "unitOfMeasure")))!
        self.init(anItemDefinition()
            .withName(name)
            .withAlias(alias)
            .withUnitNetPrice(unitNetPrice)
            .withUnitOfMeasure(unitOfMeasure)
            .withVatRateInPercent(vatRateInPercent)
            .build())
    }
    
    init(_ itemDefinition: ItemDefinition) {
        self.itemDefinition = itemDefinition
    }
    
}

/**
 The implementation of ItemDefinitionRepository using NSKeyedArchiver storage
 */
class KeyArchiverItemDefinitionRepository: ItemDefinitionRepository {
    private let itemDefinitionsKey = "itemDefinitions" + AppDelegate.keyedArchiverProfile

    func getItemDefinitions() -> [ItemDefinition] {
        return itemDefinitionsCoding.map{itemDefinitionCoding in itemDefinitionCoding.itemDefinition}
    }
    
    func addItemDefinition(_ item: ItemDefinition) {
        itemDefinitionsCoding.append(ItemDefinitionCoding(item))
    }
    
    func saveItemDefinitions(_ itemDefinitions: [ItemDefinition]) {
        itemDefinitionsCoding = itemDefinitions.map{itemDefinition in ItemDefinitionCoding(itemDefinition)}
    }
    
    private var itemDefinitionsCoding: [ItemDefinitionCoding] {
        get {
            if let data = UserDefaults.standard.object(forKey: itemDefinitionsKey) as? NSData {
                return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [ItemDefinitionCoding]
            }
            return []
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: itemDefinitionsKey)
        }
    }
}
