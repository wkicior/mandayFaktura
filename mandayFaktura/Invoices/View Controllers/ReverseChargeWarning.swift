//
//  ReverseChargeWarning.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 24/10/2020.
//  Copyright © 2020 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class ReverseChargeWarning {
    func checkIfReverseChargeShouldBeApplied(invoice: Invoice) throws {
        if (invoice.mightMissReverseCharge()) {
            let alert = NSAlert()
            alert.alertStyle = .warning
            if #available(macOS 12, *) {
                alert.messageText = String(localized: "APPLY_REVERSE_CHARGE", defaultValue: "Should reverse charge be applied?")
                alert.informativeText = String(localized: "POTENTIAL_REVERSE_CHARGE_ATTEMPT", defaultValue: "Attempting to save international invoice with no VAT rate.")
                alert.addButton(withTitle: String(localized: "YES_GO_TO_EDIT", defaultValue: "Yes, go back to editing"))
                alert.addButton(withTitle: String(localized: "NO_CONTINUE_SAVING", defaultValue: "No, continue saving"))
            } else {
                alert.messageText = "Czy zastosować odwrotne obciążenie?"
                alert.informativeText = "Próba zapisu międzynarodowej faktury z zerową stawką VAT."
                alert.addButton(withTitle: "Tak, wróć do edycji")
                alert.addButton(withTitle: "Nie, zapisz w obecnej formie")
            }
            let modalResponse = alert.runModal()
            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                throw UserAbortError()
            }
        }
    }
}

