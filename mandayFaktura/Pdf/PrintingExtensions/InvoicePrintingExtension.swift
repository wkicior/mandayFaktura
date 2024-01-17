//
//  InvoicePrintingExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

internal extension Invoice {    
    var propertiesForDisplay: [String] {
        get {
            return [self.totalNetValue.formatAmount(), "*", self.totalVatValue.formatAmount(), self.totalGrossValue.formatAmount()]
        }
    }
    
    var paymentFormLabel: String {
        switch self.paymentForm {
        case .cash:
            return self.appendI10n("gotówka", "cash")
        case .transfer:
            return self.appendI10n("przelew", "transfer")
        }
    }
    
    var printedHeader: String {
        let header =
        """
        \(appendI10n("Faktura VAT nr " + number, "Invoice no. " + number))
        """
        return header
    }
    
    var creditedNoteHeader: String {
        let header =
        """
        \(appendI10n("do faktury " + number + " z dnia " + issueDate.toDateDotString(), "issued to invoice no. " + number + " of " + issueDate.toDateDotString()))
        """
        return header
    }
    
    var printedDates: String {
        let header =
        """
        \("Data wystawienia".appendI10n("Date of issue", self.isInternational())):  \(issueDate.toDateDotString())
        \("Data sprzedaży".appendI10n("Date of sale", self.isInternational())): \(sellingDate.toDateDotString())
        """
        return header
    }
    
    var printedPaymentSummary: String {
        var summary = ""
        if (self.reverseCharge) {
            summary += appendI10n("Rozliczenie podatku", "Tax to be accounted") + ": " + appendI10n("odwrotne obciążenie", "reverse charge") + "\n"
        }
        summary +=
        """
        \(appendI10n("Do zapłaty", "Total due")): \(totalGrossValue.formatAmount()) PLN
        """
        if (self.isInternational()) {
            summary += "\n" + forI10nOnly("In words: " + totalGrossValue.spelledOutEn + " PLN")
        }
        summary += "\n" +
        """
        Słownie: \(totalGrossValue.spelledOut) PLN
        \(appendI10n("Forma płatności", "Payment form")): \(paymentFormLabel)
        \(appendI10n("Termin płatności", "Due date")): \(paymentDueDate.toDateDotString())
        \(seller.printedSellerAccountDetails(self.isInternational()))
        """
        
        return summary
    }
    
    var printedSeller: String {
        self.seller.printedSeller(self.isInternational())
    }
    
    var printedBuyer: String {
        self.buyer.printedBuyer(self.isInternational())
    }
    
    func appendI10n(_ pl: String, _ en: String) -> String {
        return pl.appendI10n(en, self.isInternational())
    }
       
    func forI10nOnly(_ en: String) -> String {
        return self.isInternational() ? en : ""
    }
    
    var itemColumnNames: [String] {
        return InvoiceItem.itemColumnNames(isI10n: self.isInternational())
    }
    
    var invoiceItemsPropertiesForDisplay: [[String]] {
        return self.items.enumerated().map {
            [($0 + 1).description] + $1.propertiesForDisplay(isI10n: self.isInternational())
        }
    }
}
