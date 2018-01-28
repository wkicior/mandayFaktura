//
//  NewInvoiceViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 28.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa

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
        NotificationCenter.default.post(name: Notification.Name(rawValue: "InvoiceAdded"), object: invoice)
        view.window?.close()
    }
}
