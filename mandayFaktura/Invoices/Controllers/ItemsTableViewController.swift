//
//  ItemsTableViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 10.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit

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
        let item1 = InvoiceItem(name: "Usługa informatyczna", amount: Decimal(1), unitOfMeasure: .hour, unitNetPrice: Decimal(10000), vatValueInPercent: Decimal(23))
        let item2 = InvoiceItem(name: "Usługa informatyczna 2", amount: Decimal(1), unitOfMeasure: .service, unitNetPrice: Decimal(120), vatValueInPercent: Decimal(8))
        items.append(item1)
        items.append(item2)
        super.init()
    }
   
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    
    
    //func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let item = items[row]
        
        if tableColumn == tableView.tableColumns[0] {
            return item.name
           
        } else if tableColumn == tableView.tableColumns[1] {
            return item.amount.description
        } else if tableColumn == tableView.tableColumns[2] {
            return item.unitOfMeasure.tag
        } else if tableColumn == tableView.tableColumns[3] {
            return item.unitNetPrice.description
        } else if tableColumn == tableView.tableColumns[4] {
            return "\(item.vatValueInPercent.description)%"
        } else if tableColumn == tableView.tableColumns[5] {
            return item.netValue.description
        } else if tableColumn == tableView.tableColumns[6] {
            return item.grossValue.description
        }
        
        return ""
        
    }
    
    
    
    func changeItemName(_ name: String) {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withName(name).build()
        }
    }
    
    func changeItemNetValue(_ netPrice: Decimal) {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withUnitNetPrice(netPrice).build()
        }
    }
    
    func changeUnitOfMeasure(index: Int) {
        let unitOfMeasure = UnitOfMeasure.byTag(index)
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withUnitOfMeasure(unitOfMeasure!).build()
        }
    }
    
    func changeAmount(_ amount: Decimal) {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withAmount(amount).build()
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
