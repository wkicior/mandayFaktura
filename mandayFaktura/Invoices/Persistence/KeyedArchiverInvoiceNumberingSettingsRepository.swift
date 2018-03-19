//
//  KeyedArchiverInvoiceNumberingSettingsRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 16.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InMemoryInvoiceNumberingSettingsRepository: InvoiceNumberingSettingsRepository {
    var invoiceNumberingSettings = InvoiceNumberingSettings(separator: "/", fixedPart: "A", templateOrderings: [.incrementingNumber, .fixedPart, .year])
    func getInvoiceNumberingSettings() -> InvoiceNumberingSettings? {
        return self.invoiceNumberingSettings
    }
    
    func save(invoiceNumberingSettings: InvoiceNumberingSettings) {
        self.invoiceNumberingSettings = invoiceNumberingSettings
    }
}

/**
 This class will provide the instances of implementations of InvoiceNumberingSettingsRepository
 */
class InvoiceNumberingSettingsRepositoryFactory {
    private static var repository: InvoiceNumberingSettingsRepository?
    
    /**
     Applicaiton registers the instance to be used as a InvoiceRepository through this method
     */
    static func register(repository: InvoiceNumberingSettingsRepository) {
        InvoiceNumberingSettingsRepositoryFactory.repository = repository
    }
    static var instance: InvoiceNumberingSettingsRepository {
        get {
            return repository!
        }
    }
}
