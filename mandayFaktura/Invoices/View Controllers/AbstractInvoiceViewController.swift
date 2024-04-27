//
//  AbstractInvoiceViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 18.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa

class AbstractInvoiceViewController: NSViewController {
    var buyerViewController: BuyerViewController?
    var itemsTableViewController: ItemsTableViewController?
    var invoiceDatesViewController: InvoiceDatesViewController?
    var paymentDetailsViewController: PaymentDetailsViewController?
    let buyerAutoSavingController = BuyerAutoSavingController()
    let invoiceFacade = InvoiceFacade()
    let counterpartyFacade = CounterpartyFacade()
    let reverseChargeWarning = ReverseChargeWarning()
    let invoiceSettings: InvoiceSettings = InvoiceSettingsFacade().getInvoiceSettings() ?? InvoiceSettings(paymentDateDays: 14)
   
    @IBOutlet weak var numberTextField: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var previewButton: NSButton!
    @IBOutlet weak var notesTextField: NSTextField!
    @IBOutlet weak var reverseChargeButton: NSButton!
    @IBOutlet weak var primaryLanguagePopUpButton: NSPopUpButton!
    @IBOutlet weak var secondLanguagePopUpButton: NSPopUpButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name:NSControl.textDidChangeNotification, object: nil)
        self.view.wantsLayer = true
        NotificationCenter.default.addObserver(forName: BuyerViewControllerConstants.BUYER_SELECTED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.checkSaveButtonEnabled()}
        NotificationCenter.default.addObserver(forName: ItemsTableViewControllerConstants.ITEM_CHANGED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.checkSaveButtonEnabled()}
    }
}

extension AbstractInvoiceViewController {
    internal func checkSaveButtonEnabled() {
        self.saveButton.isEnabled =
            self.itemsTableViewController!.isValid()
            && !self.numberTextField.stringValue.isEmpty
            && self.buyerViewController!.isValid()
    }
    
    internal func checkPreviewButtonEnabled() {
        self.previewButton.isEnabled = self.itemsTableViewController!.isValid()
    }
    
    @objc func textFieldDidChange(_ notification: Notification) {
        checkSaveButtonEnabled()
    }
}
