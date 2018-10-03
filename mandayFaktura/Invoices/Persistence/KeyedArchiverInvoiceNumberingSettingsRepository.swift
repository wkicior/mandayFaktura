//
//  KeyedArchiverInvoiceNumberingSettingsRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 16.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

@objc(NumberingSegmentCoding) private class NumberingSegmentCoding: NSObject, NSCoding {
    let numberingSegment: NumberingSegment
    
    func encode(with coder: NSCoder) {
        coder.encode(self.numberingSegment.type.rawValue, forKey: "type")
        coder.encode(self.numberingSegment.fixedValue, forKey: "fixedValue")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let fixedValue = decoder.decodeObject(forKey: "fixedValue") as? String?
            else { return nil }
        let type = NumberingSegmentType(rawValue: (decoder.decodeObject(forKey: "type") as? String)!)!
        self.init(NumberingSegment(type: type, value: fixedValue))
    }
    
    init(_ numberingSegment: NumberingSegment) {
        self.numberingSegment = numberingSegment
    }
}

@objc(InvoiceNumberingSettingsCoding) private class InvoiceNumberingSettingsCoding: NSObject, NSCoding {
    let invoiceNumberingSettings: InvoiceNumberingSettings
    
    func encode(with coder: NSCoder) {
        coder.encode(self.invoiceNumberingSettings.separator, forKey: "separator")
        coder.encode(self.invoiceNumberingSettings.segments.map{s in NumberingSegmentCoding(s)}, forKey: "segments")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let separator = decoder.decodeObject(forKey: "separator") as? String,
            let segmentsCoding = decoder.decodeObject(forKey: "segments") as? [NumberingSegmentCoding]
            else { return nil }
        let segments = segmentsCoding.map({c in c.numberingSegment})
        
        self.init(InvoiceNumberingSettings(separator: separator, segments: segments))
    }
    
    init(_ invoiceNumberingSettings: InvoiceNumberingSettings) {
        self.invoiceNumberingSettings = invoiceNumberingSettings
    }
}


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
            return InvoiceNumberingSettingsCoding(InvoiceNumberingSettings(separator: "/", segments: [NumberingSegment(type: .incrementingNumber, value: nil), NumberingSegment(type: .year, value: nil)]))
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
