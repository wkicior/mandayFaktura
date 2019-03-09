//
//  NumberingSegmentCoding.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 09.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

@objc(NumberingSegmentCoding) internal class NumberingSegmentCoding: NSObject, NSCoding {
    let numberingSegment: NumberingSegment
    
    func encode(with coder: NSCoder) {
        coder.encode(self.numberingSegment.type.rawValue, forKey: "type")
        coder.encode(self.numberingSegment.fixedValue, forKey: "fixedValue")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let fixedValue = decoder.decodeObject(forKey: "fixedValue") as? String?
            else { return nil }
        let type = NumberingSegmentType(rawValue: (decoder.decodeObject(forKey: "type") as? String)!)!
        self.init(NumberingSegment(type: type, value: fixedValue))
    }
    
    init(_ numberingSegment: NumberingSegment) {
        self.numberingSegment = numberingSegment
    }
}
