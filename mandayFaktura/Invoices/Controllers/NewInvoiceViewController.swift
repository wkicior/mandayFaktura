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
    var invoiceRepository: InvoiceRepository?
    var counterpartyRepository: CounterpartyRepository?

    @IBOutlet weak var numberTextField: NSTextField!
    @IBOutlet weak var issueDatePicker: NSDatePicker!
    @IBOutlet weak var sellingDatePicker: NSDatePicker!
    @IBOutlet weak var buyerNameTextField: NSTextField!
    @IBOutlet weak var streetAndNumberTextField: NSTextField!
    @IBOutlet weak var postalCodeTextField: NSTextField!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var taxCodeTextField: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        issueDatePicker.dateValue = Date()
        sellingDatePicker.dateValue = Date()
        let appDel = NSApplication.shared.delegate as! AppDelegate
        invoiceRepository = appDel.invoiceRepository
        counterpartyRepository = appDel.counterpartyRepository
    }
    
    @IBAction func onSaveButtonClicked(_ sender: NSButton) {
        invoiceRepository?.addInvoice(invoice)
        NotificationCenter.default.post(name: NewInvoiceViewControllerConstants.INVOICE_ADDED_NOTIFICATION, object: invoice)
        view.window?.close()
    }
    
    var invoice: Invoice {
        get {
            let seller = self.counterpartyRepository!.getSeller()
            let buyer = Counterparty(name: buyerNameTextField.stringValue, streetAndNumber: streetAndNumberTextField.stringValue, city: cityTextField.stringValue, postalCode: postalCodeTextField.stringValue, taxCode: taxCodeTextField.stringValue, accountNumber:"")
            let item1 = InvoiceItem(name: "Usługa informatyczna", amount: Decimal(1), unitOfMeasure: .service, unitNetPrice: Decimal(10000), vatValueInPercent: Decimal(23))
            let item2 = InvoiceItem(name: "Usługa informatyczna 2", amount: Decimal(1), unitOfMeasure: .service, unitNetPrice: Decimal(120), vatValueInPercent: Decimal(8))
            return Invoice(issueDate: issueDatePicker.dateValue, number: numberTextField.stringValue, sellingDate: sellingDatePicker.dateValue, seller: seller, buyer: buyer, items: [item1, item2], paymentForm: .cash, paymentDueDate: Date())
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is PdfViewController {
            let vc = segue.destinationController as? PdfViewController
            vc?.invoice = invoice
        }
    }
}
