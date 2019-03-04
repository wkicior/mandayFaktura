//
//  DocumentNumberingSettings.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 02.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation


protocol DocumentNumberingSettings {
    var separator: String { get }
    var segments: [NumberingSegment] { get }
    var resetOnYearChange: Bool { get }
}

extension DocumentNumberingSettings {
    func hasSegment(type: NumberingSegmentType) -> Bool {
        return self.segments.filter({s in s.type == type}).count > 0
    }
}
