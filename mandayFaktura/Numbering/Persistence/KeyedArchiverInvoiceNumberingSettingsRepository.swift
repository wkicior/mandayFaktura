//
//  KeyedArchiverInvoiceNumberingSettingsRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 16.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class KeyedArchiverInvoiceNumberingSettingsRepository: InvoiceNumberingSettingsRepository {
    private let key = "invoiceNumberingSettings" + AppDelegate.keyedArchiverProfile
    
    func getInvoiceNumberingSettings() -> InvoiceNumberingSettings? {
        return self.invoiceNumberingSettingsCoding.invoiceNumberingSettings
    }
    
    func save(invoiceNumberingSettings: InvoiceNumberingSettings) {
        self.invoiceNumberingSettingsCoding = InvoiceNumberingSettingsCoding(invoiceNumberingSettings)
    }
    
    private var invoiceNumberingSettingsCoding: InvoiceNumberingSettingsCoding {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? NSData {
                return  NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! InvoiceNumberingSettingsCoding
            }
            return InvoiceNumberingSettingsCoding(InvoiceNumberingSettings(separator: "/", segments: [NumberingSegment(type: .incrementingNumber, value: nil), NumberingSegment(type: .year, value: nil)], resetOnYearChange: true))
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
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
