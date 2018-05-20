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
    
    var defaultVatRates: [VatRate] = [VatRate(value: Decimal(0)),
                                      VatRate(value: Decimal(string: "0.05")!),
                                      VatRate(value: Decimal(string: "0.08")!),
                                      VatRate(value: Decimal(string: "0.23")!, isDefault: true),
                                      VatRate(value: Decimal(), literal: "zw."),
                                      VatRate(value: Decimal(), literal: "nd."),
                                      VatRate(value: Decimal(), literal: "np."),
                                      ]
    
    func getVatRates() -> [VatRate] {
        return vatRatesCoding.map{c in c.vatRate}
    }
    
    func getDefaultVatRate() -> VatRate? {
        return getVatRates().first(where: {v in v.isDefault}) ?? getVatRates().first
    }
    
    func saveVatRates(vatRates: [VatRate]) {
        vatRatesCoding = vatRates.map{v in VatRateCoding(v)}
    }
    
    func delete(_ vatRate: VatRate) {
        if let index = vatRatesCoding.index(where: {v in v.vatRate.literal == vatRate.literal}) {
            vatRatesCoding.remove(at: index)
        }
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
}
