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
    let isDefault: Bool
    
    init(value: Decimal, literal: String? = nil, isDefault: Bool = false) {
        self.value = value
        self.literal = literal ?? "\(value * 100)%"
        self.isDefault = isDefault
    }
    
    init(string: String) {
        self.literal = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let regex = try! NSRegularExpression(pattern: "^(\\d+)%$", options: [])
        let matches = regex.matches(in: self.literal, options: [], range: NSRange(location: 0, length: self.literal.count))
        var tmpValue = Decimal(0)
        if let match = matches.first {
            let range = match.range(at: 0)
            if let swiftRange = Range(range, in: self.literal) {
                tmpValue = Decimal(string: String(self.literal[swiftRange]))! / 100
            }
        }
        self.value = tmpValue
        isDefault = false
    }
    
    var special: Bool {
        get {
            return self.literal != "\(value * 100)%"
        }
    }
}
