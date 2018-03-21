//
//  NumberingSegment.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 16.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation


enum NumberingSegmentType: String {
    case year, fixedPart, incrementingNumber
    
    var regex: String {
        get {
            switch self {
            case .year:
                return "(\\d{4})"
            case .fixedPart:
                return "([\\d\\w]+)"
            case .incrementingNumber:
                return "(\\d+)"
            }
           
        }
    }
}

struct NumberingSegment {
    let type: NumberingSegmentType
    let value: String?
    
    init(type: NumberingSegmentType, value: String? = nil) {
        self.type = type
        self.value = value
    }
}


