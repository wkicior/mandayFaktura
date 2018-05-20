//
//  VatRateRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol VatRateRepository {
    func getVatRates() -> [VatRate]
    func getDefaultVatRate() -> VatRate?
    func saveVatRates(vatRates: [VatRate])
    func delete(_ vatRate: VatRate)
}


class VatRateRepositoryFactory {
    private static var repository: VatRateRepository?
    
    /**
     Applicaiton registers the instance to be used as a VatRateRepository through this method
     */
    static func register(repository: VatRateRepository) {
        VatRateRepositoryFactory.repository = repository
    }
    static var instance: VatRateRepository {
        get {
            return repository!
        }
    }
    
}
