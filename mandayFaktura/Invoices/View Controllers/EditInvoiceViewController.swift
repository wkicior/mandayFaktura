//
//  EditInvoiceViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 18.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

struct EditInvoiceViewControllerConstants {
    static let INVOICE_EDITED_NOTIFICATION = Notification.Name(rawValue: "InvoiceEdited")
}


class EditInvoiceViewController: AbstractInvoiceViewController {
    var invoice: Invoice?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buyerNameTextField.stringValue = invoice!.buyer.name
        self.numberTextField.stringValue = invoice!.number
        self.streetAndNumberTextField.stringValue = invoice!.buyer.streetAndNumber
        self.postalCodeTextField.stringValue = invoice!.buyer.postalCode
        self.cityTextField.stringValue = invoice!.buyer.city
        self.taxCodeTextField.stringValue = invoice!.buyer.taxCode
        self.cityTextField.stringValue = invoice!.buyer.city
        
        self.issueDatePicker.dateValue = invoice!.issueDate
        self.sellingDatePicker.dateValue = invoice!.sellingDate
        self.dueDatePicker.dateValue = invoice!.paymentDueDate
        self.notesTextField.stringValue = invoice!.notes
        
        let tag = getPaymentFormTag(from: invoice!.paymentForm)
        self.paymentFormPopUp.selectItem(withTag: tag)
        
        self.itemsTableViewDelegate!.items = invoice!.items
        self.itemsTableView.reloadData()
        self.previewButton.isEnabled = true
    }
    
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        do {
            try addBuyerToHistory(invoice: newInvoice)
            invoiceInteractor.editInvoice(old: invoice!, new: newInvoice)
            NotificationCenter.default.post(name: EditInvoiceViewControllerConstants.INVOICE_EDITED_NOTIFICATION, object: invoice)
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
            let vc = segue.destinationController as? PdfViewController
            vc?.invoice = newInvoice
        } else if segue.destinationController is ItemsCatalogueController {
            let vc = segue.destinationController as? ItemsCatalogueController
            vc?.invoiceController = self
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
    
    var newInvoice: Invoice {
        get {
            let seller = self.counterpartyInteractor.getSeller() ?? invoice!.seller
            let buyer = Counterparty(name: buyerNameTextField.stringValue, streetAndNumber: streetAndNumberTextField.stringValue, city: cityTextField.stringValue, postalCode: postalCodeTextField.stringValue, taxCode: taxCodeTextField.stringValue, accountNumber:"")
            return InvoiceBuilder()
                .withIssueDate(issueDatePicker.dateValue)
                .withNumber(numberTextField.stringValue)
                .withSellingDate(sellingDatePicker.dateValue)
                .withSeller(seller)
                .withBuyer(buyer)
                .withItems(self.itemsTableViewDelegate!.items)
                .withPaymentForm(selectedPaymentForm!)
                .withPaymentDueDate(self.dueDatePicker.dateValue)
                .withNotes(self.notesTextField.stringValue)
                .build()
            
        }
    }
}
