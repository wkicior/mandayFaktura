//
//  InMemoryVatRateRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InMemoryVatRateRepository: VatRateRepository {
    func getDefaultVatRate() -> VatRate {
        return VatRate(value: Decimal(23), literal: "23%")
    }
    
    func getVatRates() -> [VatRate] {
        return [VatRate(value: Decimal(0)),
                VatRate(value: Decimal(string: "0.05")!),
                VatRate(value: Decimal(string: "0.08")!),
                VatRate(value: Decimal(string: "0.23")!),
                VatRate(value: Decimal(), literal: "zw."),
                VatRate(value: Decimal(), literal: "nd."),
                VatRate(value: Decimal(), literal: "np."),
               ]
    }
}
