//
//  CounterpartyPrintingExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

extension Counterparty {
    var printedSeller: String {
        let seller =
        """
        Sprzedawca:
        \(name)
        \(streetAndNumber)
        \(postalCode) \(city)
        NIP: \(taxCode)
        Nr konta: \(accountNumber)
        """
        return seller
    }
    
    var printedBuyer: String {
        let buyer =
        """
        Nabywca:
        \(name)
        \(streetAndNumber)
        \(postalCode) \(city)
        NIP: \(taxCode)
        """
        return buyer
    }
}
