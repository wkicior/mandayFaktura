//
//  NumberingCoder.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 14.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol NumberingCoder {
    func decodeNumber(invoiceNumber: String) -> [NumberingSegment]?
    
    func encodeNumber(segments: [NumberingSegment]) -> String
}

class NumberingTemplateFactory {
    func getInstance(settings: InvoiceNumberingSettings) -> NumberingCoder {
        return NumberingSegmentCoder(delimeter: settings.separator, segmentTypes: settings.segments.map({s in s.type}))
    }
}

class NumberingSegmentCoder: NumberingCoder {
    let pattern: String
    let segmentTypes: [NumberingSegmentType]
    let separator: String
    init(delimeter: String, segmentTypes: [NumberingSegmentType]) {
        self.separator = delimeter
        self.segmentTypes = segmentTypes
        let regex = self.segmentTypes.map({type in type.regex}).joined(separator: delimeter)
        pattern = "\\b\(regex)\\b"
    }
    
    func encodeNumber(segments: [NumberingSegment]) -> String {
        return segments.map({oi in oi.fixedValue!}).joined(separator: self.separator)
    }
    
    func decodeNumber(invoiceNumber: String) -> [NumberingSegment]? {
        var result: [NumberingSegment] = []
        for i in 0 ..< self.segmentTypes.count {
            if let value = regex(from: invoiceNumber, at: i + 1) {
                result.append(NumberingSegment(type: segmentTypes[i], value: value))
            } else {
                return nil
            }
        }
        return result
    }
    
    func regex(from: String, at: Int) -> String? {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: from, options: [], range: NSRange(location: 0, length: from.count))
        if let match = matches.first {
            let range = match.range(at: at)
            if let swiftRange = Range(range, in: from) {
                return String(from[swiftRange])
            }
        }
        return nil
    }
}
