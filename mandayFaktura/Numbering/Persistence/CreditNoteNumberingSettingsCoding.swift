//
//  CreditNoteNumberingSettingsCoding.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 09.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

@objc(CreditNoteNumberingSettingsCoding) internal class CreditNoteNumberingSettingsCoding: NSObject, NSCoding {
    let creditNoteNumberingSettings: CreditNoteNumberingSettings
    
    func encode(with coder: NSCoder) {
        coder.encode(self.creditNoteNumberingSettings.separator, forKey: "separator")
        coder.encode(self.creditNoteNumberingSettings.segments.map{s in NumberingSegmentCoding(s)}, forKey: "segments")
        coder.encode(self.creditNoteNumberingSettings.resetOnYearChange, forKey: "resetOnYearChange")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let separator = decoder.decodeObject(forKey: "separator") as? String,
            let segmentsCoding = decoder.decodeObject(forKey: "segments") as? [NumberingSegmentCoding]
            else { return nil }
        let segments = segmentsCoding.map({c in c.numberingSegment})
        let resetOnYearChange = decoder.decodeBool(forKey: "resetOnYearChange") as Bool
        
        self.init(CreditNoteNumberingSettings(separator: separator, segments: segments, resetOnYearChange: resetOnYearChange))
    }
    
    init(_ creditNoteNumberingSettings: CreditNoteNumberingSettings) {
        self.creditNoteNumberingSettings = creditNoteNumberingSettings
    }
}
