//
//  ItemsTableViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 19.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

struct ItemsTableViewControllerConstants {
    static let ITEM_CHANGED_NOTIFICATION = Notification.Name(rawValue: "ItemChanged")
}

class ItemsTableViewController : NSViewController {
    
    var itemsTableViewDelegate: ItemsTableViewDelegate?
    let itemDefinitionFacade = InvoiceItemDefinitionFacade()

    let vatRateFacade = VatRateFacade()
    var _items: [InvoiceItem] = []
    
    @IBOutlet weak var itemsTableView: NSTableView!
    @IBOutlet weak var removeItemButton: NSButton!
    @IBOutlet weak var itemsCataloguqButton: NSButton!
    @IBOutlet weak var saveItemButton: NSButton!


    var items: [InvoiceItem] {
        set(value) {
            self._items = value
          
        }
        get {
            return self.itemsTableViewDelegate!.items
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableViewDelegate = ItemsTableViewDelegate(itemsTableView: itemsTableView, vatRateFacade: vatRateFacade)
        itemsTableView.delegate = itemsTableViewDelegate
        itemsTableView.dataSource = itemsTableViewDelegate
        self.itemsTableViewDelegate!.items = self._items
        self.itemsTableView.reloadData()
        self.removeItemButton.isEnabled = false
        self.saveItemButton.isEnabled = false
    }
    
    func addItem(itemDefinition: ItemDefinition) {
        self.itemsTableViewDelegate!.addItem(itemDefinition: itemDefinition)
        self.itemsTableView.reloadData()
        self.notifyItemChanged()
    }
    
    @IBAction func changeItemNetValue(_ sender: NSTextField) {
        tryWithWarning(self.itemsTableViewDelegate!.changeItemNetValue, on: sender)
        notifyItemChanged()
        self.itemsTableView.reloadData()
        setItemButtonsAvailability()
    }
    
    @IBAction func changeItemName(_ sender: NSTextField) {
        self.itemsTableViewDelegate!.changeItemName(sender)
        notifyItemChanged()
        self.itemsTableView.reloadData()
        setItemButtonsAvailability()
    }
    
    @IBAction func changeAmount(_ sender: NSTextField) {
        tryWithWarning(self.itemsTableViewDelegate!.changeAmount, on: sender)
        notifyItemChanged()
        self.itemsTableView.reloadData()
        setItemButtonsAvailability()
    }
    
    @IBAction func onVatRateSelect(_ sender: NSPopUpButton) {
        let vatRates = self.vatRateFacade.getVatRates() // this does not contain all values
        if !vatRates.isEmpty {
            let vatRate = vatRates.first(where: {v in v.literal == sender.selectedItem!.title}) ?? VatRate(string: sender.selectedItem!.title)
            self.itemsTableViewDelegate!.changeVatRate(row: sender.tag, vatRate: vatRate)
            self.itemsTableView.reloadData()
            setItemButtonsAvailability()
            notifyItemChanged()
        }
    }
    
    private func notifyItemChanged() {
        NotificationCenter.default.post(name: ItemsTableViewControllerConstants.ITEM_CHANGED_NOTIFICATION, object: nil)
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
        self.notifyItemChanged()
    }
    
    @IBAction func onMinusButtonClicked(_ sender: Any) {
        deleteSelectedItem()
    }
    
    private func deleteSelectedItem() {
        self.removeItemButton.isEnabled = false
        self.itemsTableViewDelegate!.removeSelectedItem()
        self.itemsTableView.reloadData()
        setItemButtonsAvailability()
        self.notifyItemChanged()
    }
   
    
    override func keyDown(with: NSEvent) {
        super.keyDown(with: with)
        if with.keyCode == 51 && self.itemsTableView.selectedRow != -1 {
            deleteSelectedItem()
        }
    }

    @IBAction func onTagItemButtonClicked(_ sender: NSButton) {
        let itemDefinition = anItemDefinition().from(item: self.itemsTableViewDelegate!.getSelectedItem()!).build()
        self.itemDefinitionFacade.addItemDefinition(itemDefinition)
        let invoiceItemTagAnimation = InvoiceItemTagAnimation(layer: self.view.layer!, sourceButton: self.saveItemButton, targetButton: self.itemsCataloguqButton)
        invoiceItemTagAnimation.start()
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
    
    public func isValid() -> Bool {
        return self.itemsTableView.numberOfRows > 0
        && !(self.itemsTableViewDelegate!.anyItemHasEmptyName())
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is ItemsCatalogueController {
            let vc = segue.destinationController as? ItemsCatalogueController
            vc?.itemsTableViewController = self
        }
    }
}
