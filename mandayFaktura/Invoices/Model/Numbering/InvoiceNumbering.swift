//
//  InvoiceNumbering.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

private extension Date {
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
    let invoiceRepository = InvoiceRepositoryFactory.instance
    var numberingTemplateFactory = NumberingTemplateFactory()
    var settings = InvoiceNumberingSettings(separator: "/", segments: [NumberingSegment(type: .incrementingNumber), NumberingSegment(type: .fixedPart, value: "A"), NumberingSegment(type: .year)])

    var nextInvoiceNumber: String {
        get {
            let numberingTemplate: NumberingCoder = numberingTemplateFactory.getInstance(settings: settings)
            let segments = settings.segments.map({s in buildSegment(from: s)})
            return numberingTemplate.encodeNumber(segments: segments)
        }
    }
    
    private func buildSegment(from: NumberingSegment) -> NumberingSegment {
        switch from.type {
        case .fixedPart:
            return NumberingSegment(type: from.type, value: from.fixedValue)
        case .year:
            return NumberingSegment(type: from.type, value: String(Date().year))
        case .incrementingNumber:
            let numberingTemplate: NumberingCoder = numberingTemplateFactory.getInstance(settings: settings)
            var numberingSegments = [NumberingSegment(type: from.type, value: "0")]
            if let previousNumber = invoiceRepository.getLastInvoice()?.number {
                numberingSegments = numberingTemplate.decodeNumber(invoiceNumber: previousNumber) ?? numberingSegments
            }
            let oldIncrementingNumber: Int = Int(numberingSegments.first(where: {s in s.type == .incrementingNumber})!.fixedValue!)!
            return NumberingSegment(type: from.type, value: String(oldIncrementingNumber + 1))
        }
    }
}
