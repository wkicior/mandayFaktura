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
    static func itemColumnNames(isI10n: Bool) -> [String] {
        return ["Lp.".appendI10n("No.", isI10n), "Nazwa".appendI10n("Name", isI10n), "Ilość".appendI10n("Quantity", isI10n), "jm.".appendI10n("UM", isI10n), "Cena jdn.".appendI10n("Net price", isI10n), "Wartość Netto".appendI10n("Net worth", isI10n), "Stawka VAT".appendI10n("VAT %", isI10n), "Kwota VAT".appendI10n("VAT amount", isI10n), "Wartość Brutto".appendI10n("Gross worth", isI10n)]
    }
    
    /**
     Return properties list in respectively for itemColumnNames order
     */
    func propertiesForDisplay(isI10n: Bool) -> [String] {
        return [
            self.name,
            self.amount.description,
            self.unitOfMeasureLabel(isI10n: isI10n),
            self.unitNetPrice.formatAmount(),
            self.netValue.formatAmount(),
            self.vatRate.literal,
            self.vatValue.formatAmount(),
            self.grossValue.formatAmount()
        ]
    }
    
    func unitOfMeasureLabel(isI10n: Bool) -> String {
        switch self.unitOfMeasure {
        case .hour:
            return "godz.".appendI10n("hr", isI10n)
        case .kg:
            return "kg"
        case .km:
            return "km"
        case .pieces:
            return "szt.".appendI10n("pcs.", isI10n)
        case .service:
            return "usł.".appendI10n("svc.", isI10n)
        }
    }
}
