//
//  InputValidationError.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 15.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

enum InputValidationError: Error {
    case invalidNumber(fieldName: String)
}
