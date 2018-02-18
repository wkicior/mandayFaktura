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
    static let NumberCell = "numberCellId"
    static let IssueDateCell = "issueDateCellId"
}

/**
 The controller of invoices history table view.
 Serves as delegate and the datasource for the table.
 Fetches the data from the model invoicesRepository protocol
 */
class InvoiceHistoryTableViewController : NSObject, NSTableViewDataSource, NSTableViewDelegate {
   
    let invoiceRepository: InvoiceRepository = InvoiceRepositoryFactory.instance
    let dateFormatter = DateFormatter()
    
    override init() {
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        super.init()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return invoiceRepository.getInvoices().count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        
        let item = invoiceRepository.getInvoices()[row]

        if tableColumn == tableView.tableColumns[0] {
            text = item.number
            cellIdentifier = CellIdentifiers.NumberCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = dateFormatter.string(from: item.issueDate)
            cellIdentifier = CellIdentifiers.IssueDateCell
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    func getSelectedInvoice(index: Int) -> Invoice {
        return invoiceRepository.getInvoices()[index]
    }
}
