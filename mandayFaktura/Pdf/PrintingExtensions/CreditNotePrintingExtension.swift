//
//  CreditNotePrintingExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 24.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

internal extension CreditNote {
    static let summaryColumnNames = ["Wartość Netto", "Kwota VAT", "Wartość Brutto"]
    
    var propertiesForDisplay: [String] {
        get {
            return [self.totalNetValue.formatAmount(), "*", self.totalVatValue.formatAmount(), self.totalGrossValue.formatAmount()]
        }
    }
    
    func creditNoteDifferencesPropertiesForDisplay(on: Invoice) -> [String] {
        return [self.differenceNetValue(on: on).formatAmount(), "*",  self.differenceVatValue(on: on).formatAmount(), self.differenceGrossValue(on: on).formatAmount()]

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
        Faktura korygująca nr: \(number)
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
    
    func printedPaymentSummary(on: Invoice) -> String {
        let payOrReturn = self.differenceGrossValue(on: on) > 0 ? "Do zapłaty" : "Do zwrotu"
        let summary =
        """
        \(payOrReturn): \(abs(self.differenceGrossValue(on: on)).formatAmount()) PLN
        słownie: \(abs(self.differenceGrossValue(on: on)).spelledOut) PLN
        forma płatności: \(paymentFormLabel)
        termin płatności: \(DateFormatting.getDateString(paymentDueDate))
        """
        return summary
    }
}
