//
//  InvoiceNumbering.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InvoiceNumbering: DocumentNumbering {
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
    
    func getPreviousDocumentNumber() -> String? {
        return self.invoiceRepository.getLastInvoice()?.number
    }

}
