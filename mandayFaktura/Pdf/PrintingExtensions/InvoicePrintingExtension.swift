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
            return [self.totalNetValue.formatAmount(), "*", self.totalVatValue.formatAmount(), self.totalGrossValue.formatAmount()]
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
    
    var printedHeader: String {
        let header =
        """
        Faktura VAT
        Nr: \(number)

        """
        return header
    }
    
    var creditedNoteHeader: String {
        let header =
        """
        do faktury \(number) z dnia \(DateFormatting.getDateString(issueDate))
        """
        return header
    }
    
    var printedDates: String {
        let header =
        """
        Data wystawienia: \(DateFormatting.getDateString(issueDate))
        Data sprzedaży: \(DateFormatting.getDateString(sellingDate))
        """
        return header
    }
    
    var printedPaymentSummary: String {
        let summary =
        """
        Do zapłaty: \(totalGrossValue.formatAmount()) PLN
        słownie: \(totalGrossValue.spelledOut) PLN
        forma płatności: \(paymentFormLabel)
        termin płatności: \(DateFormatting.getDateString(paymentDueDate))
        """
        return summary
    }
}
