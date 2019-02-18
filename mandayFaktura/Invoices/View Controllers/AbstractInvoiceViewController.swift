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
    let invoiceFacade = InvoiceFacade()
    let itemDefinitionFacade = InvoiceItemDefinitionFacade()
    let counterpartyFacade = CounterpartyFacade()
    let vatRateFacade = VatRateFacade()
    let invoiceSettingsFacade = InvoiceSettingsFacade()
    var itemsTableViewDelegate: ItemsTableViewDelegate?
    var selectedPaymentForm: PaymentForm? = PaymentForm.transfer
    let buyerAutoSavingController = BuyerAutoSavingController()
   
    @IBOutlet weak var numberTextField: NSTextField!
    @IBOutlet weak var issueDatePicker: NSDatePicker!
    @IBOutlet weak var sellingDatePicker: NSDatePicker!
    
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var paymentFormPopUp: NSPopUpButtonCell!
    @IBOutlet weak var dueDatePicker: NSDatePicker!
    @IBOutlet weak var itemsTableView: NSTableView!
    @IBOutlet weak var removeItemButton: NSButton!
    @IBOutlet weak var previewButton: NSButton!
    @IBOutlet weak var viewSellersPopUpButton: NSPopUpButton!
    @IBOutlet weak var saveItemButton: NSButton!
    @IBOutlet weak var itemsCataloguqButton: NSButton!
    @IBOutlet weak var notesTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        issueDatePicker.dateValue = Date()
        sellingDatePicker.dateValue = Date()
        dueDatePicker.dateValue = Calendar.current.date(byAdding: .day, value: 14, to: Date())!
        itemsTableViewDelegate = ItemsTableViewDelegate(itemsTableView: itemsTableView, vatRateFacade: vatRateFacade)
        itemsTableView.delegate = itemsTableViewDelegate
        itemsTableView.dataSource = itemsTableViewDelegate
        self.removeItemButton.isEnabled = false
       
        self.saveItemButton.isEnabled = false
        self.checkSaveButtonEnabled()
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name:NSControl.textDidChangeNotification, object: nil)
        self.view.wantsLayer = true
        let invoiceSettings = self.invoiceSettingsFacade.getInvoiceSettings() ?? InvoiceSettings(paymentDateDays: 14)
        dueDatePicker.dateValue = invoiceSettings.getDueDate(issueDate: issueDatePicker.dateValue, sellDate: sellingDatePicker.dateValue)
        notesTextField.stringValue = invoiceSettings.defaultNotes
        
        NotificationCenter.default.addObserver(forName: BuyerViewControllerConstants.BUYER_SELECTED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.checkSaveButtonEnabled()}
    }
}

extension AbstractInvoiceViewController {
    func addItem(itemDefinition: ItemDefinition) {
        self.itemsTableViewDelegate!.addItem(itemDefinition: itemDefinition)
        self.itemsTableView.reloadData()
        checkPreviewButtonEnabled()
        checkSaveButtonEnabled()
    }
    
    internal func checkSaveButtonEnabled() {
        self.saveButton.isEnabled = self.itemsTableView.numberOfRows > 0
            && !(self.itemsTableViewDelegate?.anyItemHasEmptyName())!
            && !self.numberTextField.stringValue.isEmpty
            && self.buyerViewController!.isValid()
    }
    
    internal func checkPreviewButtonEnabled() {
        self.previewButton.isEnabled = self.itemsTableView.numberOfRows > 0
    }
    
    @objc func textFieldDidChange(_ notification: Notification) {
        checkSaveButtonEnabled()
    }
}

extension AbstractInvoiceViewController {
    @IBAction func changeItemNetValue(_ sender: NSTextField) {
        tryWithWarning(self.itemsTableViewDelegate!.changeItemNetValue, on: sender)
        safeReloadData()
    }
    
    @IBAction func changeItemName(_ sender: NSTextField) {
        self.itemsTableViewDelegate!.changeItemName(sender)
        safeReloadData()
    }
    
    @IBAction func changeAmount(_ sender: NSTextField) {
        tryWithWarning(self.itemsTableViewDelegate!.changeAmount, on: sender)
        safeReloadData()
    }
    
    @IBAction func onVatRateSelect(_ sender: NSPopUpButton) {
        let vatRates = self.vatRateFacade.getVatRates() // this does not contain all values
        if !vatRates.isEmpty {
            let vatRate = vatRates.first(where: {v in v.literal == sender.selectedItem!.title}) ?? VatRate(string: sender.selectedItem!.title)
            self.itemsTableViewDelegate!.changeVatRate(row: sender.tag, vatRate: vatRate)
            safeReloadData()
        }
    }
    
    
    @IBAction func onUnitOfMeasureSelect(_ sender: NSPopUpButton) {
        self.itemsTableViewDelegate!.changeUnitOfMeasure(row: sender.tag, index: (sender.selectedItem?.tag)!)
    }
    
    @IBAction func onItemsTableViewClicked(_ sender: Any) {
        setItemButtonsAvailability()
    }
    
    private func setItemButtonsAvailability() {
        self.removeItemButton.isEnabled =  self.itemsTableView.selectedRow != -1
        self.saveItemButton.isEnabled = self.itemsTableView.selectedRow != -1
    }
    
    @IBAction func onAddItemClicked(_ sender: NSButton) {
        self.itemsTableViewDelegate!.addItem()
        self.itemsTableView.reloadData()
        checkPreviewButtonEnabled()
        checkSaveButtonEnabled()
    }
    
    @IBAction func onMinusButtonClicked(_ sender: Any) {
       deleteSelectedItem()
    }
    
    private func deleteSelectedItem() {
        self.removeItemButton.isEnabled = false
        self.itemsTableViewDelegate!.removeSelectedItem()
        safeReloadData()
        checkPreviewButtonEnabled()
        checkSaveButtonEnabled()
    }
    
    @IBAction func paymentFormPopUpValueChanged(_ sender: NSPopUpButton) {
        selectedPaymentForm = getPaymentFormByTag(sender.selectedTag())
    }
    
    @IBAction func onTagItemButtonClicked(_ sender: NSButton) {
        let itemDefinition = anItemDefinition().from(item: self.itemsTableViewDelegate!.getSelectedItem()!).build()
        self.itemDefinitionFacade.addItemDefinition(itemDefinition)
        let invoiceItemTagAnimation = InvoiceItemTagAnimation(layer: self.view.layer!, sourceButton: self.saveItemButton, targetButton: self.itemsCataloguqButton)
        invoiceItemTagAnimation.start()
    }
    
    internal func addBuyerToHistory(buyer: Counterparty) throws {
        try BuyerAutoSavingController().saveIfNewBuyer(buyer: buyer)
    }
    
    private func safeReloadData() {
        self.itemsTableView.reloadData()
        checkSaveButtonEnabled()
        setItemButtonsAvailability()
    }
    
    private func tryWithWarning(_ fun: (NSTextField) throws -> Void, on: NSTextField) {
        do {
            try fun(on)
        } catch InputValidationError.invalidNumber(let fieldName) {
            WarningAlert(warning: "\(fieldName) - błędny format liczby", text: "Zawartość pola musi być liczbą dziesiętną np. 1,23").runModal()
        } catch {
            //
        }
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
    
    override func keyDown(with: NSEvent) {
        super.keyDown(with: with)
        if with.keyCode == 51 && self.itemsTableView.selectedRow != -1 {
           deleteSelectedItem()
        }
    }

}
extension AbstractInvoiceViewController {
    @IBAction func onIssueDateSelected(_ sender: NSDatePicker) {
        let invoiceSettings = self.invoiceSettingsFacade.getInvoiceSettings()
        if (invoiceSettings != nil && invoiceSettings!.paymentDateFrom == .issueDate) {
            self.dueDatePicker.dateValue = invoiceSettings!.getDueDate(date: self.issueDatePicker.dateValue)
        }
    }
    
    @IBAction func onSellDateSelected(_ sender: NSDatePicker) {
        let invoiceSettings = self.invoiceSettingsFacade.getInvoiceSettings()
        if (invoiceSettings != nil && invoiceSettings!.paymentDateFrom == .sellDate) {
            self.dueDatePicker.dateValue = invoiceSettings!.getDueDate(date: self.sellingDatePicker.dateValue)
        }
    }
}
