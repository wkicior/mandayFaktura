//
//  VatRateRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol VatRateRepository {
    func getVatRates() -> [Decimal]
    func getDefaultVatRate() -> Decimal
}
