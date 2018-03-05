//
//  ItemDefinitionRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol ItemDefinitionRepository {
    /**
     * Gets all item definitions
     */
    func getItemDefinitions() -> [ItemDefinition]
    
    /**
     * Adds item definition to the repository
     */
    func addItemDefinition(_ item: ItemDefinition)
    
    /**
     * Overwrites item definitions with provided list
    */
    func saveItemDefinitions(_ itemDefinitions: [ItemDefinition])
}


class ItemDefinitionRepositoryFactory {
    private static var repository: ItemDefinitionRepository?
    
    /**
     Applicaiton registers the instance to be used as a ItemDefinitionRepository through this method
     */
    static func register(repository: ItemDefinitionRepository) {
        ItemDefinitionRepositoryFactory.repository = repository
    }
    static var instance: ItemDefinitionRepository {
        get {
            return repository!
        }
    }
    
}
