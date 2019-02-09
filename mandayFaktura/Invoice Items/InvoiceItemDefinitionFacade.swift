//
//  InvoiceItemDefinitionInteractor.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 21.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InvoiceItemDefinitionFacade {
    let itemDefinitionRepository = ItemDefinitionRepositoryFactory.instance
    
    func getItemDefinitions() -> [ItemDefinition] {
        return itemDefinitionRepository.getItemDefinitions()
    }
    
    func saveItemDefinitions(_ itemDefinitions: [ItemDefinition]) {
        itemDefinitionRepository.saveItemDefinitions(itemDefinitions)
    }
    
    func addItemDefinition(_ item: ItemDefinition) {
        itemDefinitionRepository.addItemDefinition(item)
    }
}
