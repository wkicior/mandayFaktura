//
//  InvoiceSettingsRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.09.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation


/**
 * The protocol for the invoice settings repository.
 * Extracting the protocol follows the IoC principle allowing to plug-in any persistance implementation without polluting the model
 */
protocol InvoiceSettingsRepository {
    /**
     Returns invoice settings
     */
    func getInvoiceSettings() -> InvoiceSettings?
    
    /**
     Saves invoice settings
     */
    func saveInvoiceSettings(_ settings: InvoiceSettings)
}

/**
 This class will provide the instances of implementations of CounterpartyRepository
 */
class InvoiceSettingsRepositoryFactory {
    private static var repository: InvoiceSettingsRepository?
    
    /**
     Applicaiton registers the instance to be used as a InvoiceSettingsRepository through this method
     */
    static func register(repository: InvoiceSettingsRepository) {
        InvoiceSettingsRepositoryFactory.repository = repository
    }
    
    static var instance: InvoiceSettingsRepository {
        get {
            return repository!
        }
    }
}
