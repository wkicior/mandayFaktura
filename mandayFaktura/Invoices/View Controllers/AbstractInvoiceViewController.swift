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
    
    let invoiceFacade = InvoiceFacade()
    let itemDefinitionFacade = InvoiceItemDefinitionFacade()
    let counterpartyFacade = CounterpartyFacade()
    let vatRateFacade = VatRateFacade()
    let invoiceSettingsFacade = InvoiceSettingsFacade()
   
    var selectedPaymentForm: PaymentForm? = PaymentForm.transfer
    let buyerAutoSavingController = BuyerAutoSavingController()
   
    @IBOutlet weak var numberTextField: NSTextField!
    
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var paymentFormPopUp: NSPopUpButtonCell!
    @IBOutlet weak var dueDatePicker: NSDatePicker!
   
    @IBOutlet weak var previewButton: NSButton!
    @IBOutlet weak var viewSellersPopUpButton: NSPopUpButton!
    @IBOutlet weak var notesTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDatePicker.dateValue = Calendar.current.date(byAdding: .day, value: 14, to: Date())!
        
       self.saveButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name:NSControl.textDidChangeNotification, object: nil)
        self.view.wantsLayer = true
        let invoiceSettings = self.invoiceSettingsFacade.getInvoiceSettings() ?? InvoiceSettings(paymentDateDays: 14)
        notesTextField.stringValue = invoiceSettings.defaultNotes
        
        NotificationCenter.default.addObserver(forName: BuyerViewControllerConstants.BUYER_SELECTED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.checkSaveButtonEnabled()}
        NotificationCenter.default.addObserver(forName: ItemsTableViewControllerConstants.ITEM_ADDED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.checkSaveButtonEnabled()}
        NotificationCenter.default.addObserver(forName: ItemsTableViewControllerConstants.ITEM_REMOVED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.checkSaveButtonEnabled()}
        NotificationCenter.default.addObserver(forName: ItemsTableViewControllerConstants.ITEM_CHANGED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.checkSaveButtonEnabled()}
        NotificationCenter.default.addObserver(forName: InvoiceDatesViewControllerConstants.ISSUE_DATE_SELECTED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.onIssueDateSelected()}
        NotificationCenter.default.addObserver(forName: InvoiceDatesViewControllerConstants.SELLING_DATE_SELECTED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.onSellingDateSelected()}
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

extension AbstractInvoiceViewController {
    
    @IBAction func paymentFormPopUpValueChanged(_ sender: NSPopUpButton) {
        selectedPaymentForm = getPaymentFormByTag(sender.selectedTag())
    }
    
    func getPaymentFormByTag(_ tag: Int) -> PaymentForm? {
        switch tag {
        case 0:
            return PaymentForm.transfer
        case 1:
            return PaymentForm.cash
        default:
            return Optional.none
        }
    }
    
    func getPaymentFormTag(from: PaymentForm) -> Int {
        switch from {
        case .transfer:
            return 0
        case .cash:
            return 1
        }
    }
    
    internal func addBuyerToHistory(buyer: Counterparty) throws {
        try BuyerAutoSavingController().saveIfNewBuyer(buyer: buyer)
    }
    
    func onIssueDateSelected() {
        let invoiceSettings = self.invoiceSettingsFacade.getInvoiceSettings()
        if (invoiceSettings != nil && invoiceSettings!.paymentDateFrom == .issueDate) {
           self.dueDatePicker.dateValue = invoiceSettings!.getDueDate(date: self.invoiceDatesViewController!.issueDate)
        }
    }
    
    func onSellingDateSelected() {
        let invoiceSettings = self.invoiceSettingsFacade.getInvoiceSettings()
        if (invoiceSettings != nil && invoiceSettings!.paymentDateFrom == .sellDate) {
          self.dueDatePicker.dateValue = invoiceSettings!.getDueDate(date: self.invoiceDatesViewController!.sellingDate)
        }
    }

}
