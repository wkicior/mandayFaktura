//
//  CounterpartyPrintingExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

extension Counterparty {
    func printedSeller(primaryLanguage: Language, secondaryLanguage: Language?, _ isInternational: Bool) -> String {
        let header = "PDF_SELLER".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "Sprzedawca".appendI10n("Seller", isInternational))
        let taxCodeLabel = "PDF_TAX_ID".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "NIP".appendI10n("Tax ID", isInternational))
        let seller =
        """
        \(header):
        \(name)
        \(streetAndNumber)
        \(postalCode) \(city) \(country)
        \(taxCodeLabel): \(taxCode)
        """
        return seller
    }
    
    func printedSellerAccountDetails(primaryLanguage: Language, secondaryLanguage: Language?, _ isInternational: Bool) -> String {
        let ibanLabel = "PDF_IBAN".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "Nr konta".appendI10n("IBAN", isInternational))
        var accountDetails =
        """
        \(ibanLabel): \(accountNumber)
        """
        if (bicCode != "") {
            accountDetails += "\nBIC/SWIFT: \(bicCode)"
        }
        return accountDetails
    }
    
    func printedBuyer(primaryLanguage: Language, secondaryLanguage: Language?, _ isInternational: Bool) -> String {
        let header = "PDF_BUYER".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "Nabywca".appendI10n("Buyer", isInternational))
        let taxCodeLabel = "PDF_TAX_ID".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "NIP".appendI10n("Tax ID", isInternational))
        let buyer =
        """
        \(header):
        \(name)
        \(streetAndNumber)
        \(postalCode) \(city) \(country)
        \(taxCodeLabel): \(taxCode)
        \(additionalInfo)
        """
        return buyer
    }
}
