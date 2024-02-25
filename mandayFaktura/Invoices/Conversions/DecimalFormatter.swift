//
//  DecimalFormatter.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 14.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

extension Decimal {
    func formatAmount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        return formatter.string(from: self as NSDecimalNumber)!.trimmingCharacters(in: .whitespaces)
    }
    
    func formatAmountDot() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ""
        return formatter.string(from: self as NSDecimalNumber)!.trimmingCharacters(in: .whitespaces)
    }
    
    func formatDecimal() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.currencyDecimalSeparator = ","
        formatter.currencyGroupingSeparator = " "
        return formatter.string(from: self as NSDecimalNumber)!.trimmingCharacters(in: .whitespaces)
    }
}
