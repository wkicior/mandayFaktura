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
    let invoiceNumberingFacade = InvoiceNumberingFacade()

    override func viewDidLoad() {
        super.viewDidLoad()
        //checkPreviewButtonEnabled()
        self.numberTextField.stringValue = invoiceNumberingFacade.getNextInvoiceNumber()
    }
    
    var invoice: Invoice {
        get {
            let seller = self.counterpartyFacade.getSeller() ?? defaultSeller()
            let buyer = self.buyerViewController?.getBuyer()
            return InvoiceBuilder()
                .withIssueDate(issueDatePicker.dateValue)
                .withNumber(numberTextField.stringValue)
                .withSellingDate(sellingDatePicker.dateValue)
                .withSeller(seller)
                .withBuyer(buyer!)
                .withItems(self.itemsTableViewController!.items)
                .withPaymentForm(selectedPaymentForm!)
                .withPaymentDueDate(self.dueDatePicker.dateValue)
                .withNotes(self.notesTextField.stringValue)
                .build()
        }
    }
    
    @IBAction func onSaveButtonClicked(_ sender: NSButton) {
        do {
            try addBuyerToHistory(buyer: invoice.buyer)
            try invoiceFacade.addInvoice(invoice)
            NotificationCenter.default.post(name: NewInvoiceViewControllerConstants.INVOICE_ADDED_NOTIFICATION, object: invoice)
            view.window?.close()
        } catch is UserAbortError {
            //
        } catch InvoiceExistsError.invoiceNumber(let number)  {
            WarningAlert(warning: "\(number) - faktura o tym numerze juź istnieje",
                text: "Zmień numer nowej faktury lub edytuj fakturę o numerze \(number)").runModal()
        } catch {
            //
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is PdfViewController {
            let vc = segue.destinationController as! PdfViewController
            vc.invoice = invoice
        } else if segue.destinationController is DatePickerViewController {
            let vc = segue.destinationController as! DatePickerViewController
            if segue.identifier == NSStoryboardSegue.Identifier("issueDatePickerSegue") {
                vc.relatedDatePicker = self.issueDatePicker
            } else if segue.identifier == NSStoryboardSegue.Identifier("sellDatePickerSegue") {
                vc.relatedDatePicker = self.sellingDatePicker
            } else if segue.identifier == NSStoryboardSegue.Identifier("dueDatePickerSegue") {
                vc.relatedDatePicker = self.dueDatePicker
            }
        } else if segue.destinationController is BuyerViewController {
            self.buyerViewController = segue.destinationController as? BuyerViewController
        } else if segue.destinationController is ItemsTableViewController {
            self.itemsTableViewController = segue.destinationController as? ItemsTableViewController
        }
    }
    
    fileprivate func defaultSeller() -> Counterparty {
        return aCounterparty()
            .withName("Firma XYZ")
            .withStreetAndNumber("Ulica 1/2")
            .withCity("Gdańsk")
            .withPostalCode("00-000")
            .withTaxCode("123456789")
            .withAccountNumber("00 1234 0000 5555 7777")
            .build()
    }
}
