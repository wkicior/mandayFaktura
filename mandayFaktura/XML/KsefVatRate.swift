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
        let result =  self.literal.replacingOccurrences(of: "%", with: "").lowercased()
        if (result.isBlank
            || !result.isNumeric
            && !result.elementsEqual("oo")
            && !result.elementsEqual("zw")
            && !result.elementsEqual("np")) {
            throw VatRateError.unrecognizedVatRate
        }
        return result
    }
    
    enum VatRateError: Error {
        case unrecognizedVatRate
    }
}

