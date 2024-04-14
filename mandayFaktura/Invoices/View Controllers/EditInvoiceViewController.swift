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
        self.saveButton.isEnabled = true
        self.previewButton.isEnabled = true
        self.numberTextField.stringValue = invoice!.number
        self.notesTextField.stringValue = invoice!.notes
        self.reverseChargeButton.state = invoice!.reverseCharge ? .on : .off
        self.primaryLanguagePopUpButton.selectItem(withTag: invoice!.primaryLanguage.index)
        self.secondLanguagePopUpButton.selectItem(withTag: invoice!.secondaryLanguage?.index ?? -1)
    }
    
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        do {
            try buyerAutoSavingController.saveIfNewBuyer(buyer: newInvoice.buyer)
            try reverseChargeWarning.checkIfReverseChargeShouldBeApplied(invoice: newInvoice)
            try invoiceFacade.editInvoice(old: invoice!, new: newInvoice)
            NotificationCenter.default.post(name: EditInvoiceViewControllerConstants.INVOICE_EDITED_NOTIFICATION, object: invoice)
            view.window?.close()
        } catch is UserAbortError {
            //
        } catch InvoiceExistsError.invoiceNumber(let number)  {
            if #available(macOS 12, *) {
                WarningAlert(warning: "\(number) - \(String(localized: "INVOICE_EXISTS", defaultValue: "the invoice with this number already exists"))",
                    text: "\(String(localized: "CHANGE_NUMBER", defaultValue: "Change new invoice number or edit invoice no")) \(number)").runModal()
            } else {
                WarningAlert(warning: "\(number) - faktura o tym numerze juź istnieje",
                    text: "Zmień numer nowej faktury lub edytuj fakturę o numerze \(number)").runModal()
            }
        } catch CreditNoteExistsError.creditNoteNumber(let number)  {
            if #available(macOS 12, *) {
                WarningAlert(warning: "\(number) - \(String(localized: "CREDIT_NOTE_EXISTS", defaultValue: "the credit note with this number already exists"))",
                    text: "\(String(localized: "CHANGE_NUMBER", defaultValue: "Change new invoice number or edit invoice no")) \(number)").runModal()
            } else {
                WarningAlert(warning: "\(number) - faktura korygująca o tym numerze juź istnieje", text: "Zmień numer nowej faktury lub edytuj fakturę o numerze \(number)").runModal()
            }
        } catch {
            //
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is ViewInvoiceController {
            let vc = segue.destinationController as? ViewInvoiceController
            let invoiceSettings = self.invoiceSettingsFacade.getInvoiceSettings()
            let pdfDocument = InvoicePdfDocument(invoice: newInvoice, invoiceSettings: invoiceSettings ?? InvoiceSettings())
            vc!.pdfDocument = pdfDocument
        } else if segue.destinationController is BuyerViewController {
            self.buyerViewController = segue.destinationController as? BuyerViewController
            self.buyerViewController!.buyer = invoice!.buyer
        } else if segue.destinationController is ItemsTableViewController {
            self.itemsTableViewController = segue.destinationController as? ItemsTableViewController
            self.itemsTableViewController!.items = invoice!.items
        } else if segue.destinationController is InvoiceDatesViewController {
            self.invoiceDatesViewController = segue.destinationController as? InvoiceDatesViewController
            self.invoiceDatesViewController!.issueDate = invoice!.issueDate
            self.invoiceDatesViewController!.sellingDate = invoice!.sellingDate
        } else if segue.destinationController is PaymentDetailsViewController {
            self.paymentDetailsViewController = segue.destinationController as? PaymentDetailsViewController
            self.paymentDetailsViewController!.dueDate = invoice!.paymentDueDate
            self.paymentDetailsViewController!.paymentForm = invoice!.paymentForm
        }
    }
    
    var newInvoice: Invoice {
        get {
            let seller = self.counterpartyFacade.getSeller() ?? invoice!.seller
            let buyer = self.buyerViewController?.getBuyer()
            let primaryLanguage = Language.ofIndex(self.primaryLanguagePopUpButton.selectedItem?.tag ?? 0)!
            let secondaryLanguage = Language.ofIndex(self.secondLanguagePopUpButton.selectedItem?.tag ?? 0)
            return InvoiceBuilder()
                .withIssueDate(invoiceDatesViewController!.issueDate)
                .withNumber(numberTextField.stringValue)
                .withSellingDate(invoiceDatesViewController!.sellingDate)
                .withSeller(seller)
                .withBuyer(buyer!)
                .withItems(self.itemsTableViewController!.items)
                .withPaymentForm(self.paymentDetailsViewController!.paymentForm!)
                .withPaymentDueDate(self.paymentDetailsViewController!.dueDate)
                .withNotes(self.notesTextField.stringValue)
                .withReverseCharge(self.reverseChargeButton.state == .on)
                .withPrimaryLanguage(primaryLanguage)
                .withSecondaryLanguage(secondaryLanguage)
                .build()
            
        }
    }
}
