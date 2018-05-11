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
}

class VatRatesTableViewDelegate: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    let vatRatesTableView: NSTableView
    var vatRates = [VatRate]()
    let vatRateRepository: VatRateRepository = VatRateRepositoryFactory.instance
    init(vatRatesTableView: NSTableView) {
        self.vatRatesTableView = vatRatesTableView
        self.vatRates = vatRateRepository.getVatRates()
        super.init()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return vatRates.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let vatRate = vatRates[row]
        let text: String = vatRate.literal
        let cellIdentifier: String = CellIdentifiers.vatRateCell
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
        
    }
    
    func removeSelectedItem() {
        let selectedRowNumber = vatRatesTableView.selectedRow
        if selectedRowNumber != -1 {
            vatRates.remove(at: selectedRowNumber)
            self.vatRateRepository.saveVatRates(vatRates: vatRates)
        }
    }
}
