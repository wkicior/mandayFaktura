//
//  StringUtilExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 13.01.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

public extension String {
    func linesCount() -> Int {
        return self.split(separator: "\u{2028}").count
    }
    
    func appendI10n(_ en: String, _ isInternational: Bool) -> String {
         return (isInternational ?  en + " | " : "") + self
    }
}
