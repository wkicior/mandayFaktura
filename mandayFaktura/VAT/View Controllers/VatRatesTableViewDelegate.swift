//
//  VatRatesTableViewDelegate.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 10.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit

fileprivate enum CellIdentifiers {
    static let vatRateCell = "vatRateCellId"
    static let defaultRateCell = "defaultRateCellId"
}

class VatRatesTableViewDelegate: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    let vatRatesTableView: NSTableView
    var vatRates: [VatRate]
    
    init(vatRatesTableView: NSTableView, vatRates: [VatRate]) {
        self.vatRatesTableView = vatRatesTableView
        self.vatRates = vatRates
        super.init()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return vatRates.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let vatRate = vatRates[row]
        if tableColumn == tableView.tableColumns[0] {
            let text: String = vatRate.literal
            let cellIdentifier: String = CellIdentifiers.vatRateCell
            
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = text
                return cell
            }
        } else if tableColumn == tableView.tableColumns[1] {
            let cellIdentifier: String = CellIdentifiers.defaultRateCell
            let isDefault = vatRate.isDefault

             if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
                
                let button = cell.subviews[0] as? NSButton
                button!.tag = row
                button!.state = isDefault ? NSControl.StateValue.on : NSControl.StateValue.off
                return cell
            }
        }
        return nil
    }
    
    func addVatRate() {
        self.vatRates.append(VatRate(value: 0.00, literal: ""))
        self.vatRatesTableView.reloadData()
    }
    
    func getSelectedVatRate() -> VatRate? {
        let selectedRowNumber = vatRatesTableView.selectedRow
        if selectedRowNumber != -1 {
            return vatRates[selectedRowNumber]
        }
        return nil
    }
    
    func updateVatRate(_ vatRate: VatRate) {
        let selectedRowNumber = vatRatesTableView.selectedRow
        if selectedRowNumber != -1 {
            vatRates[selectedRowNumber] = vatRate
            self.vatRatesTableView.reloadData()
        }
    }
    
    func setVatRates(_ vatRates: [VatRate]) {
        self.vatRates = vatRates
        self.vatRatesTableView.reloadData()
    }   
}
