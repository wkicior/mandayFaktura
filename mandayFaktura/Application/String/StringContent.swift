//
//  BlankString.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30/01/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation

public extension String {
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
    
  var isNumeric: Bool {
    return self.range(of: "^[0-9]*$", options: .regularExpression) != nil
  }
}


