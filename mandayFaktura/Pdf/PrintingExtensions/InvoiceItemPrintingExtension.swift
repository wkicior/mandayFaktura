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
    static func itemColumnNames(primaryLanguage: Language, secondaryLanguage: Language?, isI10n: Bool) -> [String] {
        return [
            "PDF_ITEM_NO".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "Lp.".appendI10n("No.", isI10n)),
            "PDF_ITEM_NAME".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent:  "Nazwa".appendI10n("Name", isI10n)),
            "PDF_ITEM_QUANTITY".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent:  "Ilość".appendI10n("Quantity", isI10n)),
            "PDF_ITEM_UOM".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent:  "jm.".appendI10n("UM", isI10n)),
            "PDF_ITEM_NET_PRICE".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent:  "Cena jdn.".appendI10n("Net price", isI10n)),
            "PDF_ITEM_NET_WORTH".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent:   "Wartość Netto".appendI10n("Net worth", isI10n)),
            "PDF_ITEM_NET_VAT".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent:    "Stawka VAT".appendI10n("VAT %", isI10n)),
            "PDF_ITEM_VAT_AMOUNT".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent:    "Kwota VAT".appendI10n("VAT amount", isI10n)),
            "PDF_ITEM_GROSS_WORTH".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent:    "Wartość Brutto".appendI10n("Gross worth", isI10n))
            ]
    }
    
    /**
     Return properties list in respectively for itemColumnNames order
     */
    func propertiesForDisplay(primaryLanguage: Language, secondaryLanguage: Language?, isI10n: Bool) -> [String] {
        return [
            self.name,
            self.amount.description,
            self.unitOfMeasureLabel(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, isI10n: isI10n),
            self.unitNetPrice.formatAmount(),
            self.netValue.formatAmount(),
            self.vatRate.literal,
            self.vatValue.formatAmount(),
            self.grossValue.formatAmount()
        ]
    }
    
    func unitOfMeasureLabel(primaryLanguage: Language, secondaryLanguage: Language?, isI10n: Bool) -> String {
        switch self.unitOfMeasure {
        case .hour:
            return "PDF_HR".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "godz.".appendI10n("hr", isI10n))
        case .kg:
            return "kg"
        case .km:
            return "km"
        case .pieces:
            return "PDF_PCS".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "szt.".appendI10n("pcs", isI10n))
        case .service:
            return "PDF_SVC".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "usł.".appendI10n("svc.", isI10n))
        }
    }
}
