//
//  InvoiceNumbering.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InvoiceNumbering {
    let invoiceRepository = InvoiceRepositoryFactory.instance
    var numberingTemplate: NumberingTemplate = IncrementWithYearNumberingTemplate(delimeter: "/", fixedPart: "A", ordering: [.incrementingNumber, .fixedPart, .year])
    var nextInvoiceNumber: String {
        get {
            var incrementedNumber: Int?
            if let previousNumber = invoiceRepository.getLastInvoice()?.number {
                incrementedNumber = (numberingTemplate.getIncrementingNumber(invoiceNumber: previousNumber) ?? 0) + 1
            }
            return numberingTemplate.getInvoiceNumber(incrementingNumber: incrementedNumber ?? 1)
        }
    }
}
