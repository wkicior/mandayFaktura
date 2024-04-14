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
    
    var locale: Locale {
        get {
            switch self {
            case .PL:
                return Locale(identifier: "pl_PL")
            case .EN:
                return Locale(identifier: "en_EN")
            }
           
        }
    }
    
    static func ofIndex(_ index: Int) -> Language? {
        switch index {
        case 0:
            return .PL
        case 1:
            return .EN
        default:
            return nil
        }
    }
    
    var index: Int {
        get {
            switch self {
            case .PL:
                return 0
            case .EN:
                return 1
            }
        }
    }
}
