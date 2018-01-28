//
//  InvoiceHistoryDataSourceController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 27.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit

fileprivate enum CellIdentifiers {
    static let NameCell = "numberCellId"
    static let DateCell = "issueDateCellId"
}

class InvoiceHistoryDataSourceController : NSObject, NSTableViewDataSource, NSTableViewDelegate {
   
    let invoicesRepository:InvoicesRepository = InMemoryInvoicesRepository()
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return invoicesRepository.getInvoices().count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long

        let item = invoicesRepository.getInvoices()[row]

        if tableColumn == tableView.tableColumns[0] {
            text = item.number
            cellIdentifier = CellIdentifiers.NameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = dateFormatter.string(from: item.issueDate)
            cellIdentifier = CellIdentifiers.DateCell
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}
