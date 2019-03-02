//
//  InvoiceNumbering.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
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

class InvoiceNumbering {
    let invoiceRepository: InvoiceRepository
    let invoiceNumberingSettingsRepository: InvoiceNumberingSettingsRepository
    var settings: DocumentNumberingSettings
    var numberingCoder: NumberingCoder
    
    init (invoiceRepository: InvoiceRepository = InvoiceRepositoryFactory.instance,
          invoiceNumberingSettingsRepository: InvoiceNumberingSettingsRepository = InvoiceNumberingSettingsRepositoryFactory.instance) {
        self.invoiceRepository = invoiceRepository
        self.invoiceNumberingSettingsRepository = invoiceNumberingSettingsRepository
        self.settings = self.invoiceNumberingSettingsRepository.getInvoiceNumberingSettings() ??
            InvoiceNumberingSettings(separator: "/", segments: [NumberingSegment(type: .incrementingNumber), NumberingSegment(type: .year)], resetOnYearChange: true)
        self.numberingCoder = NumberingSegmentCoder(delimeter: settings.separator, segmentTypes: settings.segments.map({s in s.type}))
    }
    
    public func verifyInvoiceWithNumberDoesNotExist(invoiceNumber: String) throws {
        if (invoiceRepository.findBy(invoiceNumber: invoiceNumber) != nil) {
            throw InvoiceExistsError.invoiceNumber(number: invoiceNumber)
        }
    }

    var nextInvoiceNumber: String {
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
            if let previousNumber = invoiceRepository.getLastInvoice()?.number {
                numberingSegments = numberingCoder.decodeNumber(invoiceNumber: previousNumber) ?? numberingSegments
            }
            let oldIncrementingNumber: Int = Int(numberingSegments.first(where: {s in s.type == .incrementingNumber})!.value)!
            let reset = resetOnYearChange(numberingSegments)
            return NumberingSegmentValue(type: from.type, value: String(reset ? 1 : oldIncrementingNumber + 1))
        }
    }
    
    fileprivate func resetOnYearChange(_ numberingSegments: [NumberingSegmentValue]) -> Bool {
        return settings.resetOnYearChange
            && settings.hasSegment(type: .year)
            && (numberingSegments.first(where: {s in s.type == .year})?.value != String(Date().year))
    }
}
