//
//  KeyedArchiverInvoiceSettingsRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 29.09.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class KeyedArchiverInvoiceSettingsRepository: InvoiceSettingsRepository {
    private let key = "invoiceSettings" + AppDelegate.keyedArchiverProfile
    func getInvoiceSettings() -> InvoiceSettings? {
        return invoiceSettingsCoding?.invoiceSettings
    }
    
    func saveInvoiceSettings(_ settings: InvoiceSettings) {
        invoiceSettingsCoding = InvoiceSettingsCoding(settings)
    }
    
    private var invoiceSettingsCoding: InvoiceSettingsCoding? {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? NSData {
                return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! InvoiceSettingsCoding
            }
            return nil
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
