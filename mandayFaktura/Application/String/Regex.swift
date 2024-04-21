//
//  Regex.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 21/04/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
