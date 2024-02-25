//
//  VatRateFacade.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 19.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class VatRateFacade {
    let vatRateRepository: VatRateRepository
    
    init() {
        vatRateRepository = VatRateRepositoryFactory.instance
    }
    
    init(vatRateRepository: VatRateRepository) {
        self.vatRateRepository = vatRateRepository
    }
    
    func getVatRates() -> [VatRate] {
        return vatRateRepository.getVatRates()
    }
    
    func delete(_ vatRate: VatRate) {
        vatRateRepository.delete(vatRate)
    }
    
    func saveVatRates(vatRates: [VatRate]) {
        vatRateRepository.saveVatRates(vatRates: vatRates)
    }
    
    func setDefault(isDefault: Bool, vatRate: VatRate) {
        var vatRates = vatRateRepository.getVatRates()
        if (isDefault) {
            if let currentDefaultIndex = vatRates.firstIndex(where: {v in v.isDefault}) {
                let currentDefault = vatRates[currentDefaultIndex]
                vatRates[currentDefaultIndex] = VatRate(value: currentDefault.value, literal: currentDefault.literal)
            }
        }
        let index = vatRates.firstIndex(where: {v in v.literal == vatRate.literal} )
        vatRates[index!] = VatRate(value: vatRate.value, literal: vatRate.literal, isDefault: isDefault)
        self.vatRateRepository.saveVatRates(vatRates: vatRates)
    }
    
    func getDefaultVatRate() -> VatRate? {
        return self.vatRateRepository.getDefaultVatRate()
    }
    
}
