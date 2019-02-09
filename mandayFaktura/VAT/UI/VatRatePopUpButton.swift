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
    let vatRateFacade = VatRateFacade()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let vatRates = vatRateFacade.getVatRates()
        vatRates.map({vr in vr.literal}).forEach({vr in self.addItem(withTitle: vr)})
        self.itemArray.forEach({item in item.tag = vatRates.index(where : {vr in vr.literal == item.title})!})
    }
}
