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
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCatalogueTableViewDelegate = ItemsCatalogueTableViewDelegate(itemsTableView: itemsTableView)
        itemsTableView.delegate = itemsCatalogueTableViewDelegate
        itemsTableView.dataSource = itemsCatalogueTableViewDelegate
        itemsTableView.doubleAction = #selector(onTableViewClicked)
    }
    
   
   
}

extension ItemsCatalogueController {
    
    @objc func onTableViewClicked(sender: AnyObject) {
        if (sender.selectedRow != -1) {
            let invoice = itemsCatalogueTableViewDelegate!.getSelectedInvoice(index: sender.selectedRow)
            newInvoiceController!.addItem(itemDefinition: invoice)
        }
    }
    @IBAction func onNameChange(_ sender: NSTextField) {
        self.itemsCatalogueTableViewDelegate!.changeItemName(sender)
        self.itemsTableView.reloadData()
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        self.itemsCatalogueTableViewDelegate!.saveRepository()
    }
    
    @IBAction func onAddItemDefinition(_ sender: Any) {
        self.itemsCatalogueTableViewDelegate!.addItemDefinition()
        self.itemsTableView.reloadData()
    }
    
    @IBAction func onVatRateInPercentChange(_ sender: NSPopUpButton) {
        let vatRate = Decimal(sender.selectedItem!.tag)
        self.itemsCatalogueTableViewDelegate!.changeVatRate(row: sender.tag, vatRate: vatRate)
        self.itemsTableView.reloadData()
    }
    @IBAction func onUnitNetPriceChange(_ sender: NSTextField) {
        tryWithWarning(self.itemsCatalogueTableViewDelegate!.changeItemNetValue, on: sender)
        self.itemsTableView.reloadData()
    }
    @IBAction func onUnitOfMeasureSelect(_ sender: NSPopUpButton) {
         self.itemsCatalogueTableViewDelegate!.changeUnitOfMeasure(row: sender.tag, index: (sender.selectedItem?.tag)!)
         self.itemsTableView.reloadData()
    }
    @IBAction func onAliasChange(_ sender: NSTextField) {
         self.itemsCatalogueTableViewDelegate!.changeItemAlias(sender)
         self.itemsTableView.reloadData()
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
