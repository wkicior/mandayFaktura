//
//  NewInvoiceViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 28.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa

struct NewInvoiceViewControllerConstants {
    static let INVOICE_ADDED_NOTIFICATION = Notification.Name(rawValue: "InvoiceAdded")

}

class NewInvoiceViewController: NSViewController {
    var invoiceRepository:InvoiceRepository?

    @IBOutlet weak var numberTextField: NSTextField!
    @IBOutlet weak var issueDatePicker: NSDatePicker!
    @IBOutlet weak var saveButton: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        issueDatePicker.dateValue = Date()
        let appDel = NSApplication.shared.delegate as! AppDelegate
        invoiceRepository = appDel.invoiceRepository
    }
    
    @IBAction func onSaveButtonClicked(_ sender: NSButton) {
        let invoice = Invoice(issueDate: issueDatePicker.dateValue, number: numberTextField.stringValue)
        invoiceRepository?.addInvoice(invoice)
        NotificationCenter.default.post(name: NewInvoiceViewControllerConstants.INVOICE_ADDED_NOTIFICATION, object: invoice)
        view.window?.close()
    }
}
