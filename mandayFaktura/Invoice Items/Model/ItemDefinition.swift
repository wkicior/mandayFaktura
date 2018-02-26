//
//  ItemDefinition.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct ItemDefinition {
    let name: String
    let alias: String
    let unitOfMeasure: UnitOfMeasure
    let unitNetPrice: Decimal
    let vatRateInPercent: Decimal
}
