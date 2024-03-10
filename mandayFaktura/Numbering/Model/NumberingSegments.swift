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
    
    static func validateFixedPart(value: String) throws {
        let regex = NumberingSegmentType.fixedPart.regex
        
        let fixedPartTest = NSPredicate(format:"SELF MATCHES %@", regex)
        if !fixedPartTest.evaluate(with: value) {
            if #available(macOS 12, *) {
                throw InputValidationError.invalidNumber(fieldName: String(localized: "CUSTOM_CHARACTERS", defaultValue: "Custom characters"))
            } else {
                throw InputValidationError.invalidNumber(fieldName: "Własny ciąg znaków")
            }
        }
    }
}

// NumberingSegment - definition. May contain fixed value
struct NumberingSegment {
    let type: NumberingSegmentType
    // some types (.fixedPart) may have fixed value attached
    let fixedValue: String?
    
    init(type: NumberingSegmentType, value: String? = nil) {
        self.type = type
        self.fixedValue = value
    }
}

// Numbering Segment Value - must already contain fixed or calculated value
struct NumberingSegmentValue {
    let type: NumberingSegmentType
    let value: String
}


