//
//  KsefNumber.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 17/04/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation

enum KsefNumberError: Error {
    case invalidKsefNumber(number: String)
}

struct KsefNumber {
    private let regex = try! NSRegularExpression(pattern: "([1-9]((\\d[1-9])|([1-9]\\d))\\d{7}|M\\d{9}|[A-Z]{3}\\d{7})-(20[2-9][0-9]|2[1-9][0-9]{2}|[3-9][0-9]{3})(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])-([0-9A-F]{6})-?([0-9A-F]{6})-([0-9A-F]{2})")
    let stringValue: String
    
    init(_ stringValue: String) throws {
        if !regex.matches(stringValue) {
            throw KsefNumberError.invalidKsefNumber(number: stringValue)
        }
        self.stringValue = stringValue
    }
}


