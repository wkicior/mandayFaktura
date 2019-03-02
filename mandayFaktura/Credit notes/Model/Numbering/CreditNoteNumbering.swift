//
//  CreditNoteNumbering.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 02.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class CreditNoteNumbering {
    private let creditNoteRepository: CreditNoteRepository
    var numberingCoder: NumberingCoder
    var settings: DocumentNumberingSettings
    
    init(creditNoteRepository: CreditNoteRepository = CreditNoteRepositoryFactory.instance) {
        self.creditNoteRepository = creditNoteRepository
        //TODO: get it from setting repository
        self.settings = CreditNoteNumberingSettings(separator: "/", segments: [NumberingSegment(type: .incrementingNumber), NumberingSegment(type: .year), NumberingSegment(type: .fixedPart, value: "K")], resetOnYearChange: true)
        self.numberingCoder = NumberingSegmentCoder(delimeter: settings.separator, segmentTypes: settings.segments.map({s in s.type}))
    }
    
    func verifyCreditNoteWithNumberDoesNotExist(creditNoteNumber: String) throws {
        if (creditNoteRepository.findBy(creditNoteNumber: creditNoteNumber) != nil) {
            throw CreditNoteExistsError.creditNoteNumber(number: creditNoteNumber)
        }
    }
    
    var nextCreditNoteNumber: String {
        get {
            let segments = settings.segments.map({s in buildSegmentValue(from: s)})
            return numberingCoder.encodeNumber(segments: segments)
        }
    }
    
    private func buildSegmentValue(from: NumberingSegment) -> NumberingSegmentValue {
        switch from.type {
        case .fixedPart:
            return NumberingSegmentValue(type: from.type, value: from.fixedValue ?? "")
        case .year:
            return NumberingSegmentValue(type: from.type, value: String(Date().year))
        case .incrementingNumber:
            var numberingSegments = [NumberingSegmentValue(type: from.type, value: "0")]
            if let previousNumber = creditNoteRepository.getLastCreditNote()?.number {
                numberingSegments = numberingCoder.decodeNumber(invoiceNumber: previousNumber) ?? numberingSegments
            }
            let oldIncrementingNumber: Int = Int(numberingSegments.first(where: {s in s.type == .incrementingNumber})!.value)!
            let reset = resetOnYearChange(numberingSegments)
            return NumberingSegmentValue(type: from.type, value: String(reset ? 1 : oldIncrementingNumber + 1))
        }
    }
    
    fileprivate func resetOnYearChange(_ numberingSegments: [NumberingSegmentValue]) -> Bool {
        //settings.resetOnYearChange &&
        //settings.hasSegment(type: .year) &&
        return
            (numberingSegments.first(where: {s in s.type == .year})?.value != String(Date().year))
    }
}
