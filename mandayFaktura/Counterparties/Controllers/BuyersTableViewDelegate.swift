//
//  BuyersTableViewDelegate.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit

fileprivate enum CellIdentifiers {
    static let nameCell = "nameCellId"
}

class BuyersTableViewDelegate: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    let counterpartyRepository: CounterpartyRepository = CounterpartyRepositoryFactory.instance
    
    var buyers: [Counterparty] = []
    
    override init() {
        self.buyers = counterpartyRepository.getBuyers()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return buyers.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        
        let item = buyers[row]
        
        if tableColumn == tableView.tableColumns[0] {
            text = item.name
            cellIdentifier = CellIdentifiers.nameCell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    func remove(at: Int) {
        buyers.remove(at: at)
    }
    
    func save() {
        self.counterpartyRepository.saveBuyers(buyers)
    }
    
    func reloadData() {
        self.buyers = counterpartyRepository.getBuyers()
    }
    
    func getSelectedBuyer(index: Int) -> Counterparty {
        return self.buyers[index]
    }
}

