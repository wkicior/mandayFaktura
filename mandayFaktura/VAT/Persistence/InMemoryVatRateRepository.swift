//
//  InMemoryVatRateRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InMemoryVatRateRepository: VatRateRepository {
    func getDefaultVatRate() -> Decimal {
        return Decimal(23)
    }
    
    func getVatRates() -> [Decimal] {
          return [Decimal(), Decimal(5), Decimal(8), Decimal(23)]
    }
}
