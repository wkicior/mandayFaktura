//
//  VatRateCoding.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 26.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

import Foundation

@objc(VatRateCoding) class VatRateCoding: NSObject, NSCoding {
    let vatRate: VatRate
    
    func encode(with coder: NSCoder) {
        coder.encode(self.vatRate.value, forKey: "value")
        coder.encode(self.vatRate.literal, forKey: "literal")
        coder.encode(self.vatRate.isDefault, forKey: "isDefault")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let value = decoder.decodeObject(forKey: "value") as? Decimal,
            let literal = decoder.decodeObject(forKey: "literal") as? String

            else { return nil }
        let isDefault = decoder.decodeBool(forKey: "isDefault")
        self.init(VatRate(value: value, literal: literal, isDefault: isDefault))
    }
    
    init(_ vatRate: VatRate) {
        self.vatRate = vatRate
    }
}
