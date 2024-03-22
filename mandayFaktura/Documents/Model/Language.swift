//
//  Language.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12/03/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation

enum Language: String {
    case PL, EN
    var boundleCode: String {
        get {
            switch self {
            case .PL:
                return "pl"
            case .EN:
                return "en"
            }
           
        }
    }
}
