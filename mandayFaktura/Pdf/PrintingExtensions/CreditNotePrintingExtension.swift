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
            return "PDF_INVOICE_CASH".i18n(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, defaultContent: self.appendI10n("gotówka", "cash"))
        case .transfer:
            return "PDF_INVOICE_TRANSFER".i18n(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, defaultContent: self.appendI10n("przelew", "transfer"))
        }
    }
    
    var printedDates: String {
        let issueDateHeader = "PDF_ISSUE_DATE".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "Data wystawienia".appendI10n("Date of issue", self.isInternational()))
        let saleDateHeader = "PDF_SALE_DATE".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "Data sprzedaży".appendI10n("Date of sale", self.isInternational()))
        let header =
        """
        \(issueDateHeader):  \(issueDate.toDateDotString())
        \(saleDateHeader): \(sellingDate.toDateDotString())
        """
        return header
   }
    
    var printedHeader: String {
        let headerLabel = "PDF_CREDIT_NO_NUMBER".i18n(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, defaultContent: "Faktura korygująca nr".appendI10n("Credit note no", self.isInternational()))
        let header =
        """
        \(headerLabel): \(number)
        """
        return header
    }
    
    func printedPaymentSummary(on: Invoice) -> String {
        let payOrReturn = self.differenceGrossValue(on: on) >= 0 ? "PDF_TOTAL_DUE".i18n(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, defaultContent: "Do zapłaty".appendI10n("Total due", self.isInternational()))  : "PDF_TOTAL_RETURN".i18n(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, defaultContent: "Do zwrotu".appendI10n("Total return", self.isInternational()))
        var summary = ""
        if (self.reverseCharge) {
            summary += "PDF_TAX_ACCOUNTED".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: appendI10n("Rozliczenie podatku", "Tax to be accounted")) + ": " + "PDF_REVERSE_CHARGE".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: appendI10n("odwrotne obciążenie", "reverse charge")) + "\n"
        }
        summary +=
        """
        \(payOrReturn): \(abs(self.differenceGrossValue(on: on)).formatAmount()) \(self.currency)
        """
        summary += "\n" + "PDF_IN_WORDS".i18n(language: primaryLanguage, defaultContent: "In words") + ": " + totalGrossValue.spelledOutCurrency(language: primaryLanguage, currency: self.currency)
        if (secondaryLanguage != nil) {
            summary += "\n" + "PDF_IN_WORDS".i18n(language: secondaryLanguage!, defaultContent: "Słownie") + ": " + totalGrossValue.spelledOutCurrency(language: secondaryLanguage!, currency: self.currency)
        }
        let paymentForm = "PDF_PAYMENT_FORM".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: appendI10n("Forma płatności", "Payment form"))
        let paymentDue = "PDF_PAYMENT_DUE_DATE".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: appendI10n("Termin płatności", "Due date"))
        summary += "\n" +
        """
        \(paymentForm): \(paymentFormLabel)
        \(paymentDue): \(paymentDueDate.toDateDotString())
        \(self.seller.printedSellerAccountDetails(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, isInternational()))
        """
       
        return summary
    }
    
    var printedSeller: String {
        self.seller.printedSeller(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, self.isInternational())
    }
       
    var printedBuyer: String {
        self.seller.printedBuyer(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, self.isInternational())
    }
    
    var itemColumnNames: [String] {
        return InvoiceItem.itemColumnNames(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, isI10n: self.isInternational())
    }
    
    var invoiceItemsPropertiesForDisplay: [[String]] {
        return self.items.enumerated().map {
            [($0 + 1).description] + $1.propertiesForDisplay(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, isI10n: self.isInternational())
        }
    }
    
    func appendI10n(_ pl: String, _ en: String) -> String {
        return pl.appendI10n(en, self.isInternational())
    }
    
    func forI10nOnly(_ en: String) -> String {
        return self.isInternational() ? en : ""
    }
}
