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

private extension UnitOfMeasure {
    var tag: Int {
        get {
            switch self {
            case .hour:
                return 0
            case .kg:
                return 1
            case .km:
                return 2
            case .service:
                return 3
            case .pieces:
                return 4
            }
        }
    }
    
    static func byTag(_ tag: Int) -> UnitOfMeasure? {
        switch tag {
        case 0:
            return .hour
        case 1:
            return .kg
        case 2:
            return .km
        case 3:
            return .service
        case 4:
            return .pieces
        default:
            return Optional.none
        }
    }
}



class ItemsTableViewController: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    let itemsTableView: NSTableView
    var items = [InvoiceItem]()
    
    init(itemsTableView: NSTableView) {
        self.itemsTableView = itemsTableView
        let item1 = InvoiceItem(name: "Usługa informatyczna", amount: Decimal(1), unitOfMeasure: .service, unitNetPrice: Decimal(10000), vatValueInPercent: Decimal(23))
        let item2 = InvoiceItem(name: "Usługa informatyczna 2", amount: Decimal(1), unitOfMeasure: .km, unitNetPrice: Decimal(120), vatValueInPercent: Decimal(8))
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
            cellIdentifier = CellIdentifiers.unitOfMeasureCell

            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as! NSPopUpButton
            cell.selectItem(at: item.unitOfMeasure.tag)
            cell.tag = row
            return cell
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
    
    func changeUnitOfMeasure(row: Int, index: Int) {
        let oldItem = items[row]
        items[row] = anInvoiceItem().from(source: oldItem).withUnitOfMeasure(UnitOfMeasure.byTag(index)!).build()
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
