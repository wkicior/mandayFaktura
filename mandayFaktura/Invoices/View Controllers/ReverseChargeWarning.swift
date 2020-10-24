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
            alert.messageText = "Czy zastosować odwrotne obciążenie?"
            alert.informativeText = "Próba zapisu międzynarodowej faktury z zerową stawką VAT."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Tak, wróć do edycji")
            alert.addButton(withTitle: "Nie, zapisz w obecnej formie")
            let modalResponse = alert.runModal()
            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                throw UserAbortError()
            }
        }
    }
}

