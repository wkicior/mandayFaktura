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
    var newInvoiceController: NewInvoiceViewController?
    @IBOutlet weak var itemsTableView: NSTableView!
    @IBOutlet weak var removeItemButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCatalogueTableViewDelegate = ItemsCatalogueTableViewDelegate(itemsTableView: itemsTableView)
        itemsTableView.delegate = itemsCatalogueTableViewDelegate
        itemsTableView.dataSource = itemsCatalogueTableViewDelegate
        itemsTableView.doubleAction = #selector(onTableViewDoubleClicked)
        removeItemButton.isEnabled = false
    }
}

extension ItemsCatalogueController {
    
    @objc func onTableViewDoubleClicked(sender: AnyObject) {
        if (newInvoiceController != nil && sender.selectedRow != -1) {
            let invoice = itemsCatalogueTableViewDelegate!.getSelectedInvoice(index: sender.selectedRow)
            newInvoiceController!.addItem(itemDefinition: invoice)
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
        self.itemsCatalogueTableViewDelegate!.changeItemName(sender)
        safeReloadData()
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        self.itemsCatalogueTableViewDelegate!.saveRepository()
    }
    
    @IBAction func onAddItemDefinition(_ sender: Any) {
        self.removeItemButton.isEnabled = false
        self.itemsCatalogueTableViewDelegate!.addItemDefinition()
        safeReloadData()
    }
    
    @IBAction func onRemoveItemButtonClicked(_ sender: NSButton) {
        self.itemsCatalogueTableViewDelegate!.removeSelectedItem()
        safeReloadData()
    }
    
    @IBAction func onVatRateInPercentChange(_ sender: NSPopUpButton) {
        let vatRate = Decimal(sender.selectedItem!.tag)
        self.itemsCatalogueTableViewDelegate!.changeVatRate(row: sender.tag, vatRate: vatRate)
        safeReloadData()
    }
    @IBAction func onUnitNetPriceChange(_ sender: NSTextField) {
        tryWithWarning(self.itemsCatalogueTableViewDelegate!.changeItemNetValue, on: sender)
        safeReloadData()
    }
    @IBAction func onUnitOfMeasureSelect(_ sender: NSPopUpButton) {
         self.itemsCatalogueTableViewDelegate!.changeUnitOfMeasure(row: sender.tag, index: (sender.selectedItem?.tag)!)
          safeReloadData()
    }
    
    @IBAction func onAliasChange(_ sender: NSTextField) {
         self.itemsCatalogueTableViewDelegate!.changeItemAlias(sender)
         safeReloadData()
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
}
