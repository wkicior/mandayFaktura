//
//  ItemsCatalogueController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa

class ItemsCatalogueController: NSViewController {
    var itemsCatalogueTableViewDelegate: ItemsCatalogueTableViewDelegate?
    var itemsTableViewController: ItemsTableViewController?
    let vatRateFacade = VatRateFacade()
    let invoiceItemDefinitionFacade = InvoiceItemDefinitionFacade()
    @IBOutlet weak var itemsTableView: NSTableView!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var removeItemButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCatalogueTableViewDelegate = ItemsCatalogueTableViewDelegate(itemsTableView: itemsTableView,
                                                                          vatRateFacade: vatRateFacade,
                                                                          invoiceItemDefinitionFacade: invoiceItemDefinitionFacade)
        itemsTableView.delegate = itemsCatalogueTableViewDelegate
        itemsTableView.dataSource = itemsCatalogueTableViewDelegate
        itemsTableView.doubleAction = #selector(onTableViewDoubleClicked)
        removeItemButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name:NSControl.textDidChangeNotification, object: nil)
    }
}

extension ItemsCatalogueController {
    
    @objc func textFieldDidChange(_ notification: Notification) {
        checkSaveButtonEnabledOnTableView()
    }
    
    /**
     This method can detect changes not persisted yet to model - for instance: the text field being updated
     */
    func checkSaveButtonEnabledOnTableView() {
        let allNamesAreFilled = (0 ..< itemsTableView.numberOfRows).map({c in itemsTableView.rowView(atRow: c, makeIfNecessary: false)}) // get rows
            .map({row in (row?.view(atColumn: 0) as! NSTableCellView)}) // get cells
            .map({c in c.textField?.stringValue}) //get cell text values
            .reduce(true, { (r, s) -> Bool in r && (s != nil) && !s!.isEmpty}) // checks whether all are not blank
        self.saveButton.isEnabled = allNamesAreFilled
    }
    
    func checkSaveButtonEnabledOnModel() {
        self.saveButton.isEnabled = isFormValid()
    }
    
    func isFormValid() -> Bool {
        let notFilled = itemsCatalogueTableViewDelegate?.items.first(where: { i in i.name.isEmpty })
        return notFilled == nil
    }
    
    @objc func onTableViewDoubleClicked(sender: AnyObject) {
        if (itemsTableViewController != nil && sender.selectedRow != -1 && isFormValid()) {
            let invoice = itemsCatalogueTableViewDelegate!.getSelectedInvoice(index: sender.selectedRow)
            self.itemsTableViewController!.addItem(itemDefinition: invoice)
        }
    }
    
    @IBAction func onTableViewClicked(_ sender: NSTableView) {
        setRemoveItemAvailability()
    }
    
    private func setRemoveItemAvailability() {
        self.removeItemButton.isEnabled = self.itemsTableView.selectedRow != -1
    }
    
    private func safeReloadData() {
        self.itemsTableView.reloadData()
        setRemoveItemAvailability()
    }
    
    @IBAction func onNameChange(_ sender: NSTextField) {
        self.itemsCatalogueTableViewDelegate!.changeItemName(sender.stringValue)
        safeReloadData()
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        self.itemsCatalogueTableViewDelegate!.saveRepository()
        view.window?.close()
    }
    
    @IBAction func onAddItemDefinition(_ sender: Any) {
        self.removeItemButton.isEnabled = false
        let defaultVatRate = self.vatRateFacade.getDefaultVatRate() ?? VatRate(value: 0)
        self.itemsCatalogueTableViewDelegate!.addItemDefinition(defaultVatRate: defaultVatRate)
        safeReloadData()
        self.saveButton.isEnabled = false
    }
    
    @IBAction func onRemoveItemButtonClicked(_ sender: NSButton) {
        self.itemsCatalogueTableViewDelegate!.removeSelectedItem()
        safeReloadData()
        checkSaveButtonEnabledOnModel()
    }
    
    @IBAction func onVatRateInPercentChange(_ sender: NSPopUpButton) {
        let vatRates = self.vatRateFacade.getVatRates()
        if !vatRates.isEmpty {
            let vatRate = vatRates.first(where: {v in v.literal == sender.selectedItem!.title}) ?? VatRate(string: sender.selectedItem!.title)
            self.itemsCatalogueTableViewDelegate!.changeVatRate(row: sender.tag, vatRate: vatRate)
            safeReloadData()
            checkSaveButtonEnabledOnModel()
        }
    }
    
    @IBAction func onUnitNetPriceChange(_ sender: NSTextField) {
        tryWithWarning(self.itemsCatalogueTableViewDelegate!.changeItemNetValue, on: sender)
        safeReloadData()
    }
    
    @IBAction func onUnitOfMeasureSelect(_ sender: NSPopUpButton) {
        self.itemsCatalogueTableViewDelegate!.changeUnitOfMeasure(row: sender.tag, index: (sender.selectedItem?.tag)!)
        safeReloadData()
        checkSaveButtonEnabledOnModel()
    }
    
    @IBAction func onAliasChange(_ sender: NSTextField) {
         self.itemsCatalogueTableViewDelegate!.changeItemAlias(sender)
         safeReloadData()
    }
    
    private func tryWithWarning(_ fun: (NSTextField) throws -> Void, on: NSTextField) {
        do {
            try fun(on)
        } catch InputValidationError.invalidNumber(let fieldName) {
            if #available(macOS 12, *) {
                WarningAlert(warning: "\(fieldName) - \(String(localized: "WRONG_FORMAT", defaultValue: "wrong decimal format"))", text: String(localized: "MUST_BE_DECIMAL", defaultValue: "content must be a decimal for example: 1,23")).runModal()
            } else {
                WarningAlert(warning: "\(fieldName) - błędny format liczby", text: "Zawartość pola musi być liczbą dziesiętną np. 1,23").runModal()
            }
        } catch {
            //
        }
    }
    
    override func keyDown(with: NSEvent) {
        super.keyDown(with: with)
        if with.keyCode == 51 && self.itemsTableView.selectedRow != -1 {
            self.itemsCatalogueTableViewDelegate!.removeSelectedItem()
            safeReloadData()
            checkSaveButtonEnabledOnModel()
        }
    }
}
