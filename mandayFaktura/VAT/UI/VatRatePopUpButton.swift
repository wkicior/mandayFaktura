//
//  VatRatePopUpButton.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

/**
 * PopUpButton which initializes itself with available vat rates from the repository
 */
class VatRatePopUpButton: NSPopUpButton {
    let vatRateRepository = InMemoryVatRateRepository()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        vatRateRepository.getVatRates().map({vr in "\(vr)%"}).forEach({vr in self.addItem(withTitle: vr)})
        self.itemArray.forEach({item in item.tag = Int(item.title.replacingOccurrences(of: "%", with: ""))!})
    }
}
