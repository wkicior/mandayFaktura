//
//  CorrectInvoiceViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 14.02.2019.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

struct CreditNoteViewControllerConstants {
    static let CREDIT_NOTE_CREATED_NOTIFICATION = Notification.Name(rawValue: "CreditNoteCreated")
}

class CreditNoteViewController: NSViewController {
    let creditNoteFacade = CreditNoteFacade()
    var buyerViewController: BuyerViewController?
    var itemsTableViewController: ItemsTableViewController?
    var invoiceDatesViewController: InvoiceDatesViewController?
    var paymentDetailsViewController: PaymentDetailsViewController?
    let buyerAutoSavingController = BuyerAutoSavingController()
    let invoiceFacade = InvoiceFacade()
    let counterpartyFacade = CounterpartyFacade()
    let creditNoteNumberingFacade = CreditNoteNumberingFacade()
    let invoiceSettingsFacade = InvoiceSettingsFacade()
    
    var invoice: Invoice?
    
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var previewButton: NSButton!
    @IBOutlet weak var notesTextField: NSTextField!
    @IBOutlet weak var invoiceIssueDate: NSDatePicker!
    @IBOutlet weak var creditNoteNumber: NSTextField!
    @IBOutlet weak var creditNoteIssueDate: NSDatePicker!
    @IBOutlet weak var reverseChargeButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.isEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name:NSControl.textDidChangeNotification, object: nil)
        self.view.wantsLayer = true
        NotificationCenter.default.addObserver(forName: BuyerViewControllerConstants.BUYER_SELECTED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.checkSaveButtonEnabled()}
        NotificationCenter.default.addObserver(forName: ItemsTableViewControllerConstants.ITEM_CHANGED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.checkSaveButtonEnabled()}
        self.notesTextField.stringValue = invoice!.notes
        self.previewButton.isEnabled = true
        self.creditNoteNumber.stringValue = creditNoteNumberingFacade.getNextCreditNoteNumber()
        self.reverseChargeButton.state = invoice!.reverseCharge ? .on : .off
    }
    
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        do {
            try buyerAutoSavingController.saveIfNewBuyer(buyer: invoice!.buyer)
            try creditNoteFacade.saveCreditNote(creditNote)
            NotificationCenter.default.post(name: CreditNoteViewControllerConstants.CREDIT_NOTE_CREATED_NOTIFICATION, object: invoice)
            view.window?.close()
        } catch is UserAbortError {
            //
        } catch CreditNoteExistsError.creditNoteNumber(let number)  {
            if #available(macOS 12, *) {
                WarningAlert(warning: "\(number) - \(String(localized: "CREDIT_NOTE_EXISTS", defaultValue: "the credit note with this number already exists"))",
                    text: "\(String(localized: "CHANGE_NUMBER", defaultValue: "Change new invoice number or edit invoice no")) \(number)").runModal()
            } else {
                WarningAlert(warning: "\(number) - faktura korygująca o tym numerze juź istnieje", text: "Zmień numer nowej faktury lub edytuj fakturę o numerze \(number)").runModal()
            }
        } catch InvoiceExistsError.invoiceNumber(let number)  {
            if #available(macOS 12, *) {
                WarningAlert(warning: "\(number) - \(String(localized: "INVOICE_EXISTS", defaultValue: "the invoice with this number already exists"))",
                    text: "\(String(localized: "CHANGE_NUMBER", defaultValue: "Change new invoice number or edit invoice no")) \(number)").runModal()
            } else {
                WarningAlert(warning: "\(number) - faktura o tym numerze juź istnieje",
                    text: "Zmień numer nowej faktury lub edytuj fakturę o numerze \(number)").runModal()
            }
        } catch {
            //
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is ViewInvoiceController {
            let vc = segue.destinationController as? ViewInvoiceController
            let invoiceSettings = self.invoiceSettingsFacade.getInvoiceSettings()
            vc?.pdfDocument = CreditNotePdfDocument(creditNote: creditNote, invoiceSettings: invoiceSettings ?? InvoiceSettings(paymentDateDays: 14))
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
    
    var creditNote: CreditNote {
        get {
            let seller = self.counterpartyFacade.getSeller() ?? invoice!.seller
            let buyer = self.buyerViewController!.getBuyer()
            return aCreditNote()
                .withNumber(creditNoteNumber.stringValue)
                .withIssueDate(self.invoiceDatesViewController!.issueDate)
                .withSellingDate(self.invoiceDatesViewController!.sellingDate)
                .withSeller(seller)
                .withBuyer(buyer)
                .withItems(self.itemsTableViewController!.items)
                .withPaymentForm(self.paymentDetailsViewController!.paymentForm!)
                .withReason(self.notesTextField.stringValue)
                .withInvoiceNumber(self.invoice!.number)
                .withReverseCharge(self.reverseChargeButton.state == .on)
                .build()
        }
    }
}

extension CreditNoteViewController {
    internal func checkSaveButtonEnabled() {
        self.saveButton.isEnabled =
            self.itemsTableViewController!.isValid()
            && !self.creditNoteNumber.stringValue.isEmpty
            && !self.notesTextField.stringValue.isEmpty
            && self.buyerViewController!.isValid()
    }
    
    internal func checkPreviewButtonEnabled() {
        self.previewButton.isEnabled = self.itemsTableViewController!.isValid()
    }
    
    @objc func textFieldDidChange(_ notification: Notification) {
        checkSaveButtonEnabled()
    }
}
