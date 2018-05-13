//
//  ItemsCatalogueTableViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit

fileprivate enum CellIdentifiers {
    static let nameCell = "nameCellId"
    static let aliasCell = "aliasCellId"
    static let unitOfMeasureCell = "unitOfMeasureCellId"
    static let unitNetPriceCell = "unitNetPriceCellId"
    static let vatValueCell = "vatValueCellId"
}


class ItemsCatalogueTableViewDelegate: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    let itemDefinitionRepository = ItemDefinitionRepositoryFactory.instance
    let itemsTableView: NSTableView
    let vatRateRepository = VatRateRepositoryFactory.instance
    var items: [ItemDefinition] = []
    
    init(itemsTableView: NSTableView) {
        self.itemsTableView = itemsTableView
        self.items = self.itemDefinitionRepository.getItemDefinitions()
        super.init()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        
        let item = self.items[row]
        
        if tableColumn == tableView.tableColumns[0] {
            text = item.name
            cellIdentifier = CellIdentifiers.nameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.alias
            cellIdentifier = CellIdentifiers.aliasCell
        } else if tableColumn == tableView.tableColumns[2] {
            cellIdentifier = CellIdentifiers.unitOfMeasureCell
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as! NSPopUpButton
            cell.selectItem(at: item.unitOfMeasure.tag)
            cell.tag = row
            return cell
        } else if tableColumn == tableView.tableColumns[3] {
            text = item.unitNetPrice.formatAmount()
            cellIdentifier = CellIdentifiers.unitNetPriceCell
        } else if tableColumn == tableView.tableColumns[4] {
            cellIdentifier = CellIdentifiers.vatValueCell
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as! VatRatePopUpButton
            cell.selectItem(at: self.vatRateRepository.getVatRates().index(of: item.vatRate)!)
            cell.tag = row
            return cell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    func getSelectedInvoice(index: Int) -> ItemDefinition {
        return self.items[index]
    }
    
    func changeItemName(_ name: String) {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anItemDefinition().from(source: oldItem).withName(name).build()
        }
    }
    
    func changeItemAlias(_ sender: NSTextField) {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anItemDefinition().from(source: oldItem).withAlias(sender.stringValue).build()
        }
    }
    
    func saveRepository() {
        self.itemDefinitionRepository.saveItemDefinitions(self.items)
    }
    
    func addItemDefinition() {
        self.items.append(anItemDefinition().build())
    }
    
    func changeItemNetValue(_ sender: NSTextField) throws {
        let netValue = sender.stringValue.replacingOccurrences(of: ",", with: ".")
        guard let unitNetPrice = Decimal(string: netValue) else {
            throw InputValidationError.invalidNumber(fieldName: "Cena netto")
        }
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anItemDefinition().from(source: oldItem).withUnitNetPrice(unitNetPrice).build()
        }
    }
    
    func changeUnitOfMeasure(row: Int, index: Int) {
        let oldItem = items[row]
        items[row] = anItemDefinition().from(source: oldItem).withUnitOfMeasure(UnitOfMeasure.byTag(index)!).build()
    }
    
    
    func removeSelectedItem() {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            items.remove(at: selectedRowNumber)
        }
    }
    
    func changeVatRate(row: Int, vatRate: VatRate) {
        let oldItem = items[row]
        items[row] = anItemDefinition().from(source: oldItem).withVatRate(vatRate).build()
    }
 
}
