//
//  KsefNumberViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 14/04/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Cocoa

struct KsefNumberViewControllerConstants {
    static let KSEF_NUMBER_EDITED_NOTIFICATION = Notification.Name(rawValue: "KsefNumberEdited")
}

class KsefNumberViewController: NSViewController {
    @IBOutlet weak var ksefNumberTextField: NSTextField!
    let invoiceFacade = InvoiceFacade()
    var invoice: Invoice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ksefNumberTextField.stringValue = self.invoice?.ksefNumber ?? ""
    }
    
   
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        self.invoice!.ksefNumber = ksefNumberTextField.stringValue
        NotificationCenter.default.post(name: KsefNumberViewControllerConstants.KSEF_NUMBER_EDITED_NOTIFICATION, object: self.invoice)
        do {
            try invoiceFacade.editInvoice(old: invoice!, new: invoice!)
        } catch {
            WarningAlert(warning: "Error", text: "Error on saving KSeF number").runModal()
        }
        view.window?.close()
    }

}
