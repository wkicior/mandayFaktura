//
//  CreditNotePrintingExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 24.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

internal extension CreditNote {    
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
            return "gotówka".appendI10n("cash", self.isInternational())
        case .transfer:
            return "przelew".appendI10n("transfer", self.isInternational())
        }
    }
    
    var printedDates: String {
           let header =
           """
           \("Data wystawienia".appendI10n("Date of issue", self.isInternational())):  \(DateFormatting.getDateString(issueDate))
           \("Data sprzedaży".appendI10n("Date of sale", self.isInternational())): \(DateFormatting.getDateString(sellingDate))
           """
           return header
       }
    
    var printedHeader: String {
        let header =
        """
        \("Faktura korygująca nr".appendI10n("Credit note no", self.isInternational())) : \(number)
        """
        return header
    }
    
    func printedPaymentSummary(on: Invoice) -> String {
        let payOrReturn = self.differenceGrossValue(on: on) > 0 ? "Do zapłaty".appendI10n("Total due", self.isInternational()) : "Do zwrotu".appendI10n("Total return", self.isInternational())
        var summary =
        """
        \(payOrReturn): \(abs(self.differenceGrossValue(on: on)).formatAmount()) PLN
        słownie: \(abs(self.differenceGrossValue(on: on)).spelledOut) PLN
        """
        if (self.isInternational()) {
              summary += "\n" + forI10nOnly("In words: " + totalGrossValue.spelledOutEn + " PLN")
        }
        summary += "\n" +
        """
        \(appendI10n("Forma płatności", "Payment form")): \(paymentFormLabel)
        \(appendI10n("Termin płatności", "Due date")): \(DateFormatting.getDateString(paymentDueDate))
        """
        if (self.reverseCharge) {
            summary += appendI10n("\nRozliczenie podatku", "Tax to be accounted") + ": " + appendI10n("odwrotne obciążenie", "reverse charge")
        }
        return summary
    }
    
    var printedSeller: String {
        self.seller.printedSeller(self.isInternational())
    }
       
    var printedBuyer: String {
        self.seller.printedBuyer(self.isInternational())
    }
    
    var itemColumnNames: [String] {
        return InvoiceItem.itemColumnNames(isI10n: self.isInternational())
    }
    
    var invoiceItemsPropertiesForDisplay: [[String]] {
        return self.items.enumerated().map {
            [($0 + 1).description] + $1.propertiesForDisplay(isI10n: self.isInternational())
        }
    }
    
    func appendI10n(_ pl: String, _ en: String) -> String {
        return pl.appendI10n(en, self.isInternational())
    }
    
    func forI10nOnly(_ en: String) -> String {
        return self.isInternational() ? en : ""
    }
}
