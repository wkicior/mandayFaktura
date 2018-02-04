//
//  InvoicePrintingExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

internal extension Invoice {
    static let summaryColumnNames = ["Wartość Netto", "Kwota VAT", "Wartość Brutto"]
    
    var propertiesForDisplay: [String] {
        get {
            return [self.totalNetValue.description, self.totalVatValue.description, self.totalGrossValue.description]
        }
    }
    
    var paymentFormLabel: String {
        switch self.paymentForm {
        case .cash:
            return "gotówka"
        case .transfer:
            return "przelew"
        }
    }
}
