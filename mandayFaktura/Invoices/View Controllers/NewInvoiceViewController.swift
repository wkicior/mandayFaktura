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
        self.saveButton.isEnabled = false
        notesTextField.stringValue = self.invoiceSettings.defaultNotes
        self.numberTextField.stringValue = invoiceNumberingFacade.getNextInvoiceNumber()
        self.primaryLanguagePopUpButton.selectItem(withTag: self.invoiceSettings.primaryDefaultLanguage.index)
        self.secondLanguagePopUpButton.selectItem(withTag: self.invoiceSettings.secondaryDefaultLanguage?.index ?? -1)
    }
    
    var invoice: Invoice {
        get {
            let seller = self.counterpartyFacade.getSeller() ?? defaultSeller()
            let buyer = self.buyerViewController?.getBuyer()
            let primaryLanguage = Language.ofIndex(self.primaryLanguagePopUpButton.selectedItem?.tag ?? Language.PL.index)!
            let secondaryLanguage = Language.ofIndex(self.secondLanguagePopUpButton.selectedItem?.tag ?? Language.PL.index)
            return InvoiceBuilder()
                .withIssueDate(self.invoiceDatesViewController!.issueDate)
                .withNumber(numberTextField.stringValue)
                .withSellingDate(self.invoiceDatesViewController!.sellingDate)
                .withSeller(seller)
                .withBuyer(buyer!)
                .withItems(self.itemsTableViewController!.items)
                .withPaymentForm(self.paymentDetailsViewController!.paymentForm!)
                .withPaymentDueDate(self.paymentDetailsViewController!.dueDate)
                .withNotes(self.notesTextField.stringValue)
                .withReverseCharge(self.reverseChargeButton.state == .on)
                .withPrimaryLanguage(primaryLanguage)
                .withSecondaryLanguage(secondaryLanguage)
                .withCurrency(self.invoiceSettings.defaultCurrency)
                .build()
        }
    }
    
    @IBAction func onSaveButtonClicked(_ sender: NSButton) {
        do {
            try buyerAutoSavingController.saveIfNewBuyer(buyer: invoice.buyer)
            try reverseChargeWarning.checkIfReverseChargeShouldBeApplied(invoice: invoice)
            try invoiceFacade.addInvoice(invoice)
            NotificationCenter.default.post(name: NewInvoiceViewControllerConstants.INVOICE_ADDED_NOTIFICATION, object: invoice)
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
            let vc = segue.destinationController as! ViewInvoiceController
            let pdfDocument = InvoicePdfDocument(invoice: invoice, invoiceSettings: self.invoiceSettings)
            vc.pdfDocument = pdfDocument
        } else if segue.destinationController is BuyerViewController {
            self.buyerViewController = segue.destinationController as? BuyerViewController
        } else if segue.destinationController is ItemsTableViewController {
            self.itemsTableViewController = segue.destinationController as? ItemsTableViewController
        } else if segue.destinationController is InvoiceDatesViewController {
            self.invoiceDatesViewController = segue.destinationController as? InvoiceDatesViewController
        } else if segue.destinationController is PaymentDetailsViewController {
            self.paymentDetailsViewController = segue.destinationController as? PaymentDetailsViewController
            self.paymentDetailsViewController!.dueDate = self.invoiceSettings.getDueDate(issueDate: Date(), sellDate: Date())
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
