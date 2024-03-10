//
//  BuyerSavingController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 19.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa


class BuyerAutoSavingController {
    let buyerAutoSave = BuyerAutoSave()
    func saveIfNewBuyer(buyer: Counterparty) throws {
        do {
            try buyerAutoSave.saveIfNew(buyer: buyer)
        } catch is AnotherBuyerWithThatNameExistsError {
            let alert = NSAlert()
            if #available(macOS 12, *) {
                alert.messageText = "\(String(localized: "COMPANY_EXISTS", defaultValue: "Company already exists with a name")) \(buyer.name)"
                alert.informativeText = String(localized: "COUNTERPARTIES_ARE_DIFFERENT", defaultValue: "Counterparties data is different.")
                alert.addButton(withTitle: String(localized: "CANCEL_INVOICE_SAVING", defaultValue: "Cancel invoice saving"))
                alert.addButton(withTitle: String(localized: "DO_NOT_OVERWRITE", defaultValue: "Do not overwrite"))
                alert.addButton(withTitle: String(localized: "OVERWRITE_COMPANY_DATA", defaultValue: "Overwrite company data"))
            } else {
                alert.messageText = "W historii istnieje już firma o nazwie \(buyer.name)"
                alert.informativeText = "Dane podmiotów różnią się."
                alert.addButton(withTitle: "Wstrzymaj zapis faktury")
                alert.addButton(withTitle: "Nie nadpisuj")
                alert.addButton(withTitle: "Nadpisz dane firmy")
            }
            alert.alertStyle = .warning
            let modalResponse = alert.runModal()
            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                throw UserAbortError()
            } else if modalResponse == NSApplication.ModalResponse.alertThirdButtonReturn {
                buyerAutoSave.update(buyer: buyer)
            }
        }
    }
}
