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
    static let numberCell = "numberCellId"
    static let issueDateCell = "issueDateCellId"
    static let buyerName = "buyerNameCellId"
    static let grossValueCell = "grossValueCellId"
}

/**
 The controller of document list table view.
 Serves as delegate and the datasource for the table.
 Fetches the data from invoices and credit note facades
 */
class DocumentListTableViewDelegate : NSObject, NSTableViewDataSource, NSTableViewDelegate {
    let invoiceFacade: InvoiceFacade
    let creditNoteFacade: CreditNoteFacade
    
    let dateFormatter = DateFormatter()
    
    init(invoiceFacade: InvoiceFacade, creditNoteFacade: CreditNoteFacade) {
        self.invoiceFacade = invoiceFacade
        self.creditNoteFacade = creditNoteFacade
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        super.init()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.getDocumentList().count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        
        let item = self.getDocumentList()[row]

        if tableColumn == tableView.tableColumns[0] {
            text = item.number
            cellIdentifier = CellIdentifiers.numberCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = dateFormatter.string(from: item.issueDate)
            cellIdentifier = CellIdentifiers.issueDateCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = item.buyer.name           
            cellIdentifier = CellIdentifiers.buyerName
        } else if tableColumn == tableView.tableColumns[3] {
            text = item.totalGrossValue.formatAmount()
            cellIdentifier = CellIdentifiers.grossValueCell
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    fileprivate func getDocumentList() -> [Document] {
        let documents = invoiceFacade.getInvoices() as [Document] + creditNoteFacade.getCreditNotes() as [Document]
        return documents.sorted(by: {$0.issueDate > $1.issueDate})
    }
    
    func getSelectedDocument(index: Int) -> Document {
        return self.getDocumentList()[index]
    }
}
