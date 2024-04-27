//
//  CurrencyPopUpButton.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 26/04/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

/**
 * PopUpButton which initializes itself with available vat rates from the repository
 */
class CurrencyPopUpButton: NSPopUpButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let currencies = Currency.allCases
        currencies.forEach {currency in self.addItem(withTitle: currency.rawValue)}
        self.itemArray.forEach {item in item.tag = Currency(rawValue: item.title)!.index}
    }
}
