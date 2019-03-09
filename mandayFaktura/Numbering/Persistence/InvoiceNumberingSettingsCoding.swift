//
//  InvoiceNumberingSettingsCoding.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 09.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

@objc(InvoiceNumberingSettingsCoding) internal class InvoiceNumberingSettingsCoding: NSObject, NSCoding {
    let invoiceNumberingSettings: InvoiceNumberingSettings
    
    func encode(with coder: NSCoder) {
        coder.encode(self.invoiceNumberingSettings.separator, forKey: "separator")
        coder.encode(self.invoiceNumberingSettings.segments.map{s in NumberingSegmentCoding(s)}, forKey: "segments")
        coder.encode(self.invoiceNumberingSettings.resetOnYearChange, forKey: "resetOnYearChange")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let separator = decoder.decodeObject(forKey: "separator") as? String,
            let segmentsCoding = decoder.decodeObject(forKey: "segments") as? [NumberingSegmentCoding]
            else { return nil }
        let segments = segmentsCoding.map({c in c.numberingSegment})
        let resetOnYearChange = decoder.decodeBool(forKey: "resetOnYearChange") as Bool
        
        self.init(InvoiceNumberingSettings(separator: separator, segments: segments, resetOnYearChange: resetOnYearChange))
    }
    
    init(_ invoiceNumberingSettings: InvoiceNumberingSettings) {
        self.invoiceNumberingSettings = invoiceNumberingSettings
    }
}
