//
//  KeyArchiverVatRateRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 13.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class KeyArchiverVatRateRepository: VatRateRepository {
    private let vatRateDefinitionsKey = "vatRates" + AppDelegate.keyedArchiverProfile
    private let defaultVatRateDefinitionKey = "defaultVatRate" + AppDelegate.keyedArchiverProfile
    
    var defaultVatRates: [VatRate] = [VatRate(value: Decimal(0)),
                                      VatRate(value: Decimal(string: "0.05")!),
                                      VatRate(value: Decimal(string: "0.08")!),
                                      VatRate(value: Decimal(string: "0.23")!),
                                      VatRate(value: Decimal(), literal: "zw."),
                                      VatRate(value: Decimal(), literal: "nd."),
                                      VatRate(value: Decimal(), literal: "np."),
                                      ]
    
    func getVatRates() -> [VatRate] {
        return vatRatesCoding.map{c in c.vatRate}
    }
    
    func getDefaultVatRate() -> VatRate? {
        let vatRates = getVatRates()
        return defaultVatRateCoding.map{c in c.vatRate} ?? (vatRates.isEmpty ? nil : vatRates[0])
    }
    
    func saveVatRates(vatRates: [VatRate]) {
        vatRatesCoding = vatRates.map{v in VatRateCoding(v)}
    }
    
    private var vatRatesCoding: [VatRateCoding] {
        get {
            if let data = UserDefaults.standard.object(forKey: vatRateDefinitionsKey) as? NSData {
                return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [VatRateCoding]
            } else {
                self.vatRatesCoding = defaultVatRates.map{v in VatRateCoding(v)}
                return self.vatRatesCoding
            }
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: vatRateDefinitionsKey)
        }
    }
    
    private var defaultVatRateCoding: VatRateCoding? {
        get {
            if let data = UserDefaults.standard.object(forKey: defaultVatRateDefinitionKey) as? NSData {
                return (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! VatRateCoding)
            }
            return nil
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue!)
            UserDefaults.standard.set(data, forKey: defaultVatRateDefinitionKey)
        }
        
    }
    
    
}
