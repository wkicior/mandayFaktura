//
//  KeyedArchiverCreditNoteNumberingSettingsRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 09.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class KeyedArchiverCreditNoteNumberingSettingsRepository: CreditNoteNumberingSettingsRepository {
    private let key = "creditNoteNumberingSettings" + AppDelegate.keyedArchiverProfile
    
    func getCreditNoteNumberingSettings() -> CreditNoteNumberingSettings? {
        return self.creditNoteNumberingSettingsCoding.creditNoteNumberingSettings
    }
    
    func save(creditNoteNumberingSettings: CreditNoteNumberingSettings) {
        self.creditNoteNumberingSettingsCoding = CreditNoteNumberingSettingsCoding(creditNoteNumberingSettings)
    }
    
    private var creditNoteNumberingSettingsCoding: CreditNoteNumberingSettingsCoding {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? NSData {
                return  NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! CreditNoteNumberingSettingsCoding
            }
            return CreditNoteNumberingSettingsCoding(CreditNoteNumberingSettings(separator: "/", segments: [NumberingSegment(type: .fixedPart, value: "K"), NumberingSegment(type: .incrementingNumber, value: nil), NumberingSegment(type: .year, value: nil)], resetOnYearChange: true))
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

/**
 This class will provide the instances of implementations of creditNoteNumberingSettingsRepository
 */
class CreditNoteNumberingSettingsRepositoryFactory {
    private static var repository: CreditNoteNumberingSettingsRepository?
    
    /**
     Applicaiton registers the instance to be used as a creditNoteRepository through this method
     */
    static func register(repository: CreditNoteNumberingSettingsRepository) {
        CreditNoteNumberingSettingsRepositoryFactory.repository = repository
    }
    static var instance: CreditNoteNumberingSettingsRepository {
        get {
            return repository!
        }
    }
}
