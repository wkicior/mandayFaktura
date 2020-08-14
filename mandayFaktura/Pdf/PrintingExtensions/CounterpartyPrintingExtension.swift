//
//  CounterpartyPrintingExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

extension Counterparty {
    func printedSeller(_ isInternational: Bool) -> String {
        let seller =
        """
        \("Sprzedawca".appendI10n("Seller", isInternational)):
        \(name)
        \(streetAndNumber)
        \(postalCode) \(city) \(country)
        \("NIP".appendI10n("Tax ID", isInternational)): \(taxCode)
        \("Nr konta".appendI10n("IBAN", isInternational)): \(accountNumber)
        """
        return seller
    }
    
    func printedBuyer(_ isInternational: Bool) -> String {
        let buyer =
        """
        \("Nabywca".appendI10n("Buyer", isInternational)):
        \(name)
        \(streetAndNumber)
        \(postalCode) \(city) \(country)
         \("NIP".appendI10n("Tax ID", isInternational)): \(taxCode)
        \(additionalInfo)
        """
        return buyer
    }
}
