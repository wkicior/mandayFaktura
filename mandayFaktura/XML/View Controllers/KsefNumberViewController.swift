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
        self.ksefNumberTextField.stringValue = self.invoice?.ksefNumber?.stringValue ?? ""
    }
    
   
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        do {
        self.invoice!.ksefNumber = try KsefNumber(ksefNumberTextField.stringValue)
        NotificationCenter.default.post(name: KsefNumberViewControllerConstants.KSEF_NUMBER_EDITED_NOTIFICATION, object: self.invoice)
            try invoiceFacade.editInvoice(old: invoice!, new: invoice!)
        } catch KsefNumberError.invalidKsefNumber(_) {
            if #available(macOS 12, *) {
                WarningAlert(warning: String(localized: "ERROR", defaultValue: "Błąd"), text: "\(String(localized: "WRONG_KSEF_NUMBER", defaultValue: "Incorrect KSeF number"))").runModal()
            } else {
                WarningAlert(warning: "Error", text: "Niepoprawny numer KSeF").runModal()
            }
        }
        catch {
            if #available(macOS 12, *) {
                WarningAlert(warning: String(localized: "ERROR", defaultValue: "Błąd"), text: "\(String(localized: "SAVING_KSEF_ERROR", defaultValue: "Error on saving KSeF number"))").runModal()
            } else {
                WarningAlert(warning: "Error", text: "Error on saving KSeF number").runModal()
            }
           
        }
        view.window?.close()
    }

}
