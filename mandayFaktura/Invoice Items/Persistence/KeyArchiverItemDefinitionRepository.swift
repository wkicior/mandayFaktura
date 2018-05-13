//
//  KeyArchiverItemDefinitionRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 07.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

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
