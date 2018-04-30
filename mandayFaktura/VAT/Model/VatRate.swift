//
//  VatRate.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct VatRate: Hashable {
    
    
    let value: Decimal
    let literal: String
    
    init(value: Decimal, literal: String? = nil) {
        self.value = value
        self.literal = literal ?? "\(value * 100)%"
    }
    
    var special: Bool {
        get {
            return self.literal != "\(value * 100)%"
        }
    }
}
