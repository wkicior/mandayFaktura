//
//  File.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 09.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

extension Date {
    var year: Int {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: Date())
            return Int(year)!
        }
    }
}

protocol DocumentNumbering {
    var settings: DocumentNumberingSettings { get set }
    var numberingCoder: NumberingCoder { get set }
    
    func getPreviousDocumentNumber() -> String?
}

extension DocumentNumbering {
    func resetOnYearChange(_ numberingSegments: [NumberingSegmentValue]) -> Bool {
        return settings.resetOnYearChange
            && settings.hasSegment(type: .year)
            && (numberingSegments.first(where: {s in s.type == .year})?.value != String(Date().year))
    }
    
    func buildSegmentValue(from: NumberingSegment) -> NumberingSegmentValue {
        switch from.type {
        case .fixedPart:
            return NumberingSegmentValue(type: from.type, value: from.fixedValue ?? "")
        case .year:
            return NumberingSegmentValue(type: from.type, value: String(Date().year))
        case .incrementingNumber:
            return NumberingSegmentValue(type: from.type, value: getNewIncrementingNumber())
        }
    }
    
    func getNewIncrementingNumber() -> String {
        var numberingSegments = [NumberingSegmentValue(type: .incrementingNumber, value: "0")]
        if let previousNumber = getPreviousDocumentNumber() {
            numberingSegments = numberingCoder.decodeNumber(invoiceNumber: previousNumber) ?? numberingSegments
        }
        let oldIncrementingNumber: Int = Int(numberingSegments.first(where: {s in s.type == .incrementingNumber})!.value)!
        let reset = resetOnYearChange(numberingSegments)
        return  String(reset ? 1 : oldIncrementingNumber + 1)
    }
}
