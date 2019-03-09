//
//  CreditNoteNumbering.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 02.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class CreditNoteNumbering: DocumentNumbering {
    var settings: DocumentNumberingSettings
    var numberingCoder: NumberingCoder
    private let creditNoteNumberingSettingsRepository = CreditNoteNumberingSettingsRepositoryFactory.instance
    private let creditNoteRepository: CreditNoteRepository
    let previousNumber: String?
    
    init(creditNoteRepository: CreditNoteRepository = CreditNoteRepositoryFactory.instance) {
        self.creditNoteRepository = creditNoteRepository
        self.previousNumber = self.creditNoteRepository.getLastCreditNote()?.number
        self.settings = self.creditNoteNumberingSettingsRepository.getCreditNoteNumberingSettings() ?? CreditNoteNumberingSettings(separator: "/", segments: [NumberingSegment(type: .incrementingNumber), NumberingSegment(type: .year), NumberingSegment(type: .fixedPart, value: "K")], resetOnYearChange: true)
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
    
    func getPreviousDocumentNumber() -> String? {
        return creditNoteRepository.getLastCreditNote()?.number
    }
}
