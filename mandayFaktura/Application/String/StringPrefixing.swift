//
//  StringPrefixes.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 07/01/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation


public extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
