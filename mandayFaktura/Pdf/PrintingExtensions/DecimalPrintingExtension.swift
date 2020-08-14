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
    
    
    var spelledOut: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.spellOut
            let spelledOutInt = numberFormatter.string(from: NSNumber(integerLiteral: self.int))!
            return  "\(spelledOutInt) \(self.fractionalPart.description)/100"
        }
    }
    
    var spelledOutEn: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale(identifier: "en_EN")
            numberFormatter.numberStyle = NumberFormatter.Style.spellOut
            let spelledOutInt = numberFormatter.string(from: NSNumber(integerLiteral: self.int))!
            return  "\(spelledOutInt) \(self.fractionalPart.description)/100"
        }
    }
}
