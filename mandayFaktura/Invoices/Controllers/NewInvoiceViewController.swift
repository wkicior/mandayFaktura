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
        let seller = Counterparty(name: "Firma Krzak", streetAndNumber: "Bolesława 4/12", city: "Warszawka", postalCode: "00-000", taxCode: "123456789", accountNumber:"PL0000111122223333")
        let buyer = Counterparty(name: "Firma XYZ", streetAndNumber: "Miłosza 4/12", city: "Szczebocin", postalCode: "00-000", taxCode: "123456789", accountNumber:"")
        let invoice = Invoice(issueDate: issueDatePicker.dateValue, number: numberTextField.stringValue, sellingDate: Date(), seller: seller, buyer: buyer, items: [])
        invoiceRepository?.addInvoice(invoice)
        NotificationCenter.default.post(name: NewInvoiceViewControllerConstants.INVOICE_ADDED_NOTIFICATION, object: invoice)
        view.window?.close()
    }
}
