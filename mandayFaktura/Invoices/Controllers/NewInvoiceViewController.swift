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


class NewInvoiceViewController: AbstractInvoiceViewController {
   
    let invoiceNumberingInteractor = InvoiceNumberingInteractor()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkPreviewButtonEnabled()
        self.numberTextField.stringValue = invoiceNumberingInteractor.getNextInvoiceNumber()
    }
    
    var invoice: Invoice {
        get {
            let seller = self.counterpartyInteractor.getSeller() ?? Counterparty(name: "Firma XYZ", streetAndNumber: "Ulica 1/2", city: "Gdańsk", postalCode: "00-000", taxCode: "123456789", accountNumber: "00 1234 0000 5555 7777")
            let buyer = Counterparty(name: buyerNameTextField.stringValue, streetAndNumber: streetAndNumberTextField.stringValue, city: cityTextField.stringValue, postalCode: postalCodeTextField.stringValue, taxCode: taxCodeTextField.stringValue, accountNumber:"")
            return Invoice(issueDate: issueDatePicker.dateValue, number: numberTextField.stringValue, sellingDate: sellingDatePicker.dateValue, seller: seller, buyer: buyer, items:  self.itemsTableViewDelegate!.items, paymentForm: selectedPaymentForm!, paymentDueDate: self.dueDatePicker.dateValue)
        }
    }
    
    @IBAction func onSaveButtonClicked(_ sender: NSButton) {
        do {
            try addBuyerToHistory(invoice: invoice)
            try invoiceRepository.addInvoice(invoice)
            NotificationCenter.default.post(name: NewInvoiceViewControllerConstants.INVOICE_ADDED_NOTIFICATION, object: invoice)
            view.window?.close()
        } catch is UserAbortError {
            //
        } catch InvoiceExistsError.invoiceNumber(let number)  {
            WarningAlert(warning: "\(number) - faktura o tym numerze juź istnieje", text: "Zmień numer nowej faktury lub edytuj fakturę o numerze \(number)").runModal()
        } catch {
            //
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is PdfViewController {
            let vc = segue.destinationController as! PdfViewController
            vc.invoice = invoice
        } else if segue.destinationController is ItemsCatalogueController {
            let vc = segue.destinationController as! ItemsCatalogueController
            vc.invoiceController = self
        } else if segue.destinationController is DatePickerViewController {
            let vc = segue.destinationController as! DatePickerViewController
            if segue.identifier == NSStoryboardSegue.Identifier("issueDatePickerSegue") {
                vc.relatedDatePicker = self.issueDatePicker
            } else if segue.identifier == NSStoryboardSegue.Identifier("sellDatePickerSegue") {
                vc.relatedDatePicker = self.sellingDatePicker
            } else if segue.identifier == NSStoryboardSegue.Identifier("dueDatePickerSegue") {
                vc.relatedDatePicker = self.dueDatePicker
            }
        }
    }
}
