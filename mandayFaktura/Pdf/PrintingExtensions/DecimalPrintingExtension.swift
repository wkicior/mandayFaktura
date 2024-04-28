//
//  DecimalPrintingExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

internal extension Decimal {
    var int: Int {
        get {
            let result = NSDecimalNumber(decimal: self)
            return Int(truncating: result)
        }
    }
    
    var fractionalPart: Decimal {
        get {
            return 100 * (self - Decimal(int))
        }
    }
    
    func spelledOutCurrency(language: Language, currency: Currency) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = language.locale
        numberFormatter.numberStyle = NumberFormatter.Style.spellOut
        let spelledOutInt = numberFormatter.string(from: NSNumber(integerLiteral: self.int))!
        let spelledoutCents = numberFormatter.string(from: NSNumber(integerLiteral: self.fractionalPart.int))!
        let unknownCentsPart = self.fractionalPart > 0 ? " \(spelledoutCents) \(currency.rawValue)/100" : ""
        let centsPart = currency.centsKey != nil ? " \(spelledoutCents) \(currency.centsKey!)" : unknownCentsPart
        return  "\(spelledOutInt) \(currency.rawValue)\(centsPart)"
    }
}
