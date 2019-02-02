//
//  InvoiceNumberingSettings.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 16.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct InvoiceNumberingSettings {
    let separator: String
    let segments: [NumberingSegment]
    let resetOnYearChange: Bool
    
    func hasSegment(type: NumberingSegmentType) -> Bool {
        return self.segments.filter({s in s.type == type}).count > 0
    }
}
