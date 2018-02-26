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


class ItemsCatalogueTableViewController: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    let itemsTableView: NSTableView
    var items = [ItemDefinition]()
    let vatRateRepository = InMemoryVatRateRepository()
    
    init(itemsTableView: NSTableView) {
        self.itemsTableView = itemsTableView
        let item1 = ItemDefinition(name: "Usługa informatyczna", alias: "Usługa test 1", unitOfMeasure: .service, unitNetPrice: Decimal(10000), vatRateInPercent: Decimal(23))
        let item2 = ItemDefinition(name: "Usługa informatyczna 2", alias: "Usługa test 2", unitOfMeasure: .km, unitNetPrice: Decimal(120), vatRateInPercent: Decimal(8))
        items.append(item1)
        items.append(item2)
        super.init()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        
        let item = items[row]
        
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
            cell.selectItem(at: self.vatRateRepository.getVatRates().index(of: item.vatRateInPercent)!)
            cell.tag = row
            return cell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    /*func changeItemName(_ sender: NSTextField) {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withName(sender.stringValue).build()
        }
    }
    
    func changeItemNetValue(_ sender: NSTextField) throws {
        guard let unitNetPrice = Decimal(string: sender.stringValue) else {
            throw InputValidationError.invalidNumber(fieldName: "Cena netto")
        }
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withUnitNetPrice(unitNetPrice).build()
        }
    }
    
    func changeAmount(_ sender: NSTextField) throws {
        guard let amount = Decimal(string: sender.stringValue) else {
            throw InputValidationError.invalidNumber(fieldName: "Ilość")
        }
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withAmount(amount).build()
        }
    }
    
    func changeUnitOfMeasure(row: Int, index: Int) {
        let oldItem = items[row]
        items[row] = anInvoiceItem().from(source: oldItem).withUnitOfMeasure(UnitOfMeasure.byTag(index)!).build()
    }
    
    func addItem() {
        let defaultVatRate = self.vatRateRepository.getDefaultVatRate()
        items.append(anInvoiceItem().withVatRateInPercent(defaultVatRate).withUnitOfMeasure(.pieces).build())
    }
    
    func removeSelectedItem() {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            items.remove(at: selectedRowNumber)
        }
    }
    
    func changeVatRate(row: Int, vatRate: Decimal) {
        let oldItem = items[row]
        items[row] = anInvoiceItem().from(source: oldItem).withVatRateInPercent(vatRate).build()
    }
 */
}
