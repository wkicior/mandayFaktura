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
    
    func spelledOut(language: Language) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = language.locale
        numberFormatter.numberStyle = NumberFormatter.Style.spellOut
        let spelledOutInt = numberFormatter.string(from: NSNumber(integerLiteral: self.int))!
        return  "\(spelledOutInt) \(self.fractionalPart.description)/100"
    }
}
