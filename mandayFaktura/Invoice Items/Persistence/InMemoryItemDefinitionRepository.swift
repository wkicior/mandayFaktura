//
//  InMemoryItemDefinitionRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InMemoryItemDefinitionRepository: ItemDefinitionRepository {
    private var itemDefinitions: [ItemDefinition] = [ItemDefinition(name: "Usługa1", alias: "Usługa1", unitOfMeasure: .service, unitNetPrice: 1000, vatRateInPercent: 23)]
    func getItemDefinitions() -> [ItemDefinition] {
        return itemDefinitions
    }
    
    func addItemDefinition(_ item: ItemDefinition) {
        itemDefinitions.append(item)
    }
    
    func saveItemDefinitions(_ itemDefinitions: [ItemDefinition]) {
        self.itemDefinitions = itemDefinitions
    }
}
