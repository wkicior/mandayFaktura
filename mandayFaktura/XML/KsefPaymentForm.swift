//
//  KsefPaymentForm.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 17/01/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation

extension PaymentForm {
    func toKsefCode() -> Int {
        switch self {
        case .cash: return 1
        case .transfer: return 6
        }
    }
}
