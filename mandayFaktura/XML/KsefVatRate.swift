//
//  KsefVatRate.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03/02/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation

extension VatRate {
    func toKsefCode() throws -> String {
        let result =  self.literal.replacingOccurrences(of: "%", with: "")
        if (result.isBlank
            || result.elementsEqual("0")
            || !result.isNumeric            
            && !result.elementsEqual("0 WDT")
            && !result.elementsEqual("0 KR")
            && !result.elementsEqual("0 EX")
            && !result.elementsEqual("oo")
            && !result.elementsEqual("zw")
            && !result.elementsEqual("np I")
            && !result.elementsEqual("np II")) {
            throw VatRateError.unrecognizedVatRate
        }
        return result
    }
    
    public enum VatRateError: Error {
        case unrecognizedVatRate
    }
}

