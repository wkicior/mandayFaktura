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
            alert.messageText = "W historii istnieje już firma o nazwie \(buyer.name)"
            alert.informativeText = "Dane podmiotów różnią się."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Wstrzymaj zapis faktury")
            alert.addButton(withTitle: "Nie nadpisuj")
            alert.addButton(withTitle: "Nadpisz dane firmy")
            let modalResponse = alert.runModal()
            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                throw UserAbortError()
            } else if modalResponse == NSApplication.ModalResponse.alertThirdButtonReturn {
                buyerAutoSave.update(buyer: buyer)
            }
        }
    }
}
