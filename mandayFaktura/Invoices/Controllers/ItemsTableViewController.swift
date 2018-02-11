//
//  ItemsTableViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 10.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit

fileprivate enum CellIdentifiers {
    static let nameCell = "nameCellId"
    static let amountCell = "amountCellId"
    static let unitOfMeasureCell = "unitOfMeasureCellId"
    static let unitNetPriceCell = "unitNetPriceCellId"
    static let vatValueCell = "vatValueCellId"
    static let netValueCell = "netValueCellId"
    static let grossValueCell = "grossValueCellId"
}


class ItemsTableViewController: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    let itemsTableView: NSTableView
    var items = [InvoiceItem]()
    
    init(itemsTableView: NSTableView) {
        self.itemsTableView = itemsTableView
        let item1 = InvoiceItem(name: "Usługa informatyczna", amount: Decimal(1), unitOfMeasure: .service, unitNetPrice: Decimal(10000), vatValueInPercent: Decimal(23))
        let item2 = InvoiceItem(name: "Usługa informatyczna 2", amount: Decimal(1), unitOfMeasure: .service, unitNetPrice: Decimal(120), vatValueInPercent: Decimal(8))
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
            text = item.amount.description
            cellIdentifier = CellIdentifiers.amountCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = item.unitOfMeasureLabel
            cellIdentifier = CellIdentifiers.unitOfMeasureCell
        } else if tableColumn == tableView.tableColumns[3] {
            text = item.unitNetPrice.description
            cellIdentifier = CellIdentifiers.unitNetPriceCell
        } else if tableColumn == tableView.tableColumns[4] {
            text = "\(item.vatValueInPercent.description)%"
            cellIdentifier = CellIdentifiers.vatValueCell
        } else if tableColumn == tableView.tableColumns[5] {
            text = item.netValue.description
            cellIdentifier = CellIdentifiers.netValueCell
        } else if tableColumn == tableView.tableColumns[6] {
            text = item.grossValue.description
            cellIdentifier = CellIdentifiers.grossValueCell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    func changeItemName(_ sender: NSTextField) {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withName(sender.stringValue).build()
        }
    }
    
    func changeItemNetValue(_ sender: NSTextField) {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withUnitNetPrice(Decimal(string: sender.stringValue)!).build()
        }
    }
    
    func changeAmount(_ sender: NSTextField) {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withAmount(Decimal(string: sender.stringValue)!).build()
        }
    }
    
    func addItem() {
        items.append(anInvoiceItem().withUnitOfMeasure(.hour).build())
    }
    
    func removeSelectedItem() {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            items.remove(at: selectedRowNumber)
        }
    }
}
