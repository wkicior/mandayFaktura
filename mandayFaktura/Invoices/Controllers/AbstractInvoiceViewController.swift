//
//  AbstractInvoiceViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 18.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa

class AbstractInvoiceViewController: NSViewController {
    let invoiceRepository = InvoiceRepositoryFactory.instance
    let itemDefinitionRepository = ItemDefinitionRepositoryFactory.instance
    let counterpartyRepository:CounterpartyRepository = CounterpartyRepositoryFactory.instance
    var itemsTableViewDelegate: ItemsTableViewDelegate?
    var selectedPaymentForm: PaymentForm? = PaymentForm.transfer
    let buyerAutoSavingController =  BuyerAutoSavingController()
    
    @IBOutlet weak var numberTextField: NSTextField!
    @IBOutlet weak var issueDatePicker: NSDatePicker!
    @IBOutlet weak var sellingDatePicker: NSDatePicker!
    @IBOutlet weak var buyerNameTextField: NSTextField!
    @IBOutlet weak var streetAndNumberTextField: NSTextField!
    @IBOutlet weak var postalCodeTextField: NSTextField!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var taxCodeTextField: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var paymentFormPopUp: NSPopUpButtonCell!
    @IBOutlet weak var dueDatePicker: NSDatePicker!
    @IBOutlet weak var itemsTableView: NSTableView!
    @IBOutlet weak var removeItemButton: NSButton!
    @IBOutlet weak var previewButton: NSButton!
    @IBOutlet weak var viewSellersPopUpButton: NSPopUpButton!
    @IBOutlet weak var saveItemButton: NSButton!
    @IBOutlet weak var itemsCataloguqButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        issueDatePicker.dateValue = Date()
        sellingDatePicker.dateValue = Date()
        dueDatePicker.dateValue = Date()
        itemsTableViewDelegate = ItemsTableViewDelegate(itemsTableView: itemsTableView)
        itemsTableView.delegate = itemsTableViewDelegate
        itemsTableView.dataSource = itemsTableViewDelegate
        self.removeItemButton.isEnabled = false
        checkPreviewButtonEnabled()
        self.counterpartyRepository.getBuyers().forEach{buyer in viewSellersPopUpButton.addItem(withTitle: buyer.name)}
        self.saveItemButton.isEnabled = false
        self.checkSaveButtonEnabled()
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name:NSControl.textDidChangeNotification, object: nil)
    }
    
}

extension AbstractInvoiceViewController {
    func addItem(itemDefinition: ItemDefinition) {
        self.itemsTableViewDelegate!.addItem(itemDefinition: itemDefinition)
        self.itemsTableView.reloadData()
        checkPreviewButtonEnabled()
    }
    
    internal func checkSaveButtonEnabled() {
        self.saveButton.isEnabled = self.itemsTableView.numberOfRows > 0
            && !self.numberTextField.stringValue.isEmpty
            && !self.buyerNameTextField.stringValue.isEmpty
            && !self.streetAndNumberTextField.stringValue.isEmpty
            && !self.postalCodeTextField.stringValue.isEmpty
            && !self.taxCodeTextField.stringValue.isEmpty
            && !self.cityTextField.stringValue.isEmpty
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
        let vatRate = Decimal(sender.selectedItem!.tag)
        self.itemsTableViewDelegate!.changeVatRate(row: sender.tag, vatRate: vatRate)
        safeReloadData()
    }
    
    @IBAction func onSelectBuyerButtonClicked(_ sender: NSPopUpButton) {
        let buyerName = sender.selectedItem?.title
        let buyer = self.counterpartyRepository.getBuyer(name: buyerName!)
        setBuyer(buyer: buyer ?? aCounterparty().build())
        checkSaveButtonEnabled()
    }
    
    private func setBuyer(buyer: Counterparty) {
        self.buyerNameTextField.stringValue = buyer.name
        self.streetAndNumberTextField.stringValue = buyer.streetAndNumber
        self.cityTextField.stringValue = buyer.city
        self.postalCodeTextField.stringValue = buyer.postalCode
        self.taxCodeTextField.stringValue = buyer.taxCode
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
    }
    
    @IBAction func onMinusButtonClicked(_ sender: Any) {
        self.removeItemButton.isEnabled = false
        self.itemsTableViewDelegate!.removeSelectedItem()
        safeReloadData()
        checkPreviewButtonEnabled()
    }
    
    @IBAction func paymentFormPopUpValueChanged(_ sender: NSPopUpButton) {
        selectedPaymentForm = getPaymentFormByTag(sender.selectedTag())
    }
    
    @IBAction func onTagItemButtonClicked(_ sender: NSButton) {
        let itemDefinition = anItemDefinition().from(item: self.itemsTableViewDelegate!.getSelectedItem()!).build()
        self.itemDefinitionRepository.addItemDefinition(itemDefinition)
    }
    
    internal func addBuyerToHistory(invoice: Invoice) throws {
        try BuyerAutoSavingController().saveIfNewBuyer(buyer: invoice.buyer)
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
    
}
