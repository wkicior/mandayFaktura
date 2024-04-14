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
            return "PDF_INVOICE_CASH".i18n(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, defaultContent: self.appendI10n("gotówka", "cash"))
        case .transfer:
            return "PDF_INVOICE_TRANSFER".i18n(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, defaultContent: self.appendI10n("przelew", "transfer"))
        }
    }
    
    var printedHeader: String {
        let secondLanguageContent: String = "PDF_INVOICE_NO".i18n(language: secondaryLanguage ?? primaryLanguage, defaultContent: "Faktura VAT nr") + " " + number
        let primaryLanguageContent: String = "PDF_INVOICE_NO".i18n(language: primaryLanguage, defaultContent: "Invoice no.") + " " + number
        return secondLanguageContent.appendI10n(primaryLanguageContent, secondaryLanguage != nil)
    }
    
    var creditedNoteHeader: String {
        let secondLanguageContent: String = "PDF_ISSUED_TO_INVOICE_NO".i18n(language: secondaryLanguage ?? primaryLanguage, defaultContent: "do faktury") + " " + number + " " + "PDF_OF_DAY".i18n(language: secondaryLanguage ?? primaryLanguage, defaultContent: "z dnia") + " " + issueDate.toDateDotString()
        let primaryLanguageContent: String = "PDF_ISSUED_TO_INVOICE_NO".i18n(language: primaryLanguage, defaultContent: "issued to invoice no.") + " " + number + " " + "PDF_OF_DAY".i18n(language: primaryLanguage, defaultContent: "of") + " " +  issueDate.toDateDotString()
        return secondLanguageContent.appendI10n(primaryLanguageContent, secondaryLanguage != nil)
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
    
    var printedPaymentSummary: String {
        var summary = ""
        if (self.reverseCharge) {
            summary += "PDF_TAX_ACCOUNTED".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: appendI10n("Rozliczenie podatku", "Tax to be accounted")) + ": " + "PDF_REVERSE_CHARGE".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: appendI10n("odwrotne obciążenie", "reverse charge")) + "\n"
        }
        let totalDue = "PDF_TOTAL_DUE".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: appendI10n("Do zapłaty", "Total due"))
        summary +=
        """
        \(totalDue): \(totalGrossValue.formatAmount()) PLN
        """
        summary += "\n" + "PDF_IN_WORDS".i18n(language: primaryLanguage, defaultContent: "In words") + ": " + totalGrossValue.spelledOut(language: primaryLanguage) + " PLN"
        if (secondaryLanguage != nil) {
            summary += "\n" + "PDF_IN_WORDS".i18n(language: secondaryLanguage!, defaultContent: "Słownie") + ": " + totalGrossValue.spelledOut(language: secondaryLanguage!) + " PLN"
        }
        let paymentForm = "PDF_PAYMENT_FORM".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: appendI10n("Forma płatności", "Payment form"))
        let paymentDue = "PDF_PAYMENT_DUE_DATE".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: appendI10n("Termin płatności", "Due date"))
        summary += "\n" +
        """
        \(paymentForm): \(paymentFormLabel)
        \(paymentDue): \(paymentDueDate.toDateDotString())
        \(seller.printedSellerAccountDetails(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, self.isInternational()))
        """
        
        return summary
    }
    
    var printedSeller: String {
        self.seller.printedSeller(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, self.isInternational())
    }
    
    var printedBuyer: String {
        self.buyer.printedBuyer(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, self.isInternational())
    }
    
    func appendI10n(_ pl: String, _ en: String) -> String {
        return pl.appendI10n(en, self.isInternational())
    }
       
    func forI10nOnly(_ en: String) -> String {
        return self.isInternational() ? en : ""
    }
    
    var itemColumnNames: [String] {
        return InvoiceItem.itemColumnNames(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, isI10n: self.isInternational())
    }
    
    var invoiceItemsPropertiesForDisplay: [[String]] {
        return self.items.enumerated().map {
            [($0 + 1).description] + $1.propertiesForDisplay(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, isI10n: self.isInternational())
        }
    }
}
