//
//  InvoiceItemPrintingExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

/**
 * Extension providing printing properties of the invoice item on invoice
 */
internal extension InvoiceItem {
    static let itemColumnNames = ["Lp", "Nazwa", "Ilość", "jm.", "Cena jdn.", "Wartość Netto", "Stawka VAT", "Kwota VAT", "Wartość Brutto"]
    
    /**
     Return properties list in respectively for itemColumnNames order
     */
    var propertiesForDisplay: [String] {
        get {
            return [self.name, self.amount.description, unitOfMeasureLabel, self.unitNetPrice.description,
                    self.netValue.description, "\(self.vatValueInPercent.description)%", self.vatValue.description, self.grossValue.description]
        }
    }
    
    var unitOfMeasureLabel: String {
        switch self.unitOfMeasure {
        case .hour:
            return "godz."
        case .kg:
            return "kg"
        case .km:
            return "km"
        case .pieces:
            return "szt."
        case .service:
            return "usł."
        }
    }
}
