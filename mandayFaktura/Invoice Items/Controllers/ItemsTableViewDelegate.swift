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

extension UnitOfMeasure {
    static let ordering: [UnitOfMeasure] = [.hour, .kg, .km, .service, .pieces]
    var tag: Int {
        get {
            return UnitOfMeasure.ordering.index(of: self)!
        }
    }
    
    static func byTag(_ tag: Int) -> UnitOfMeasure? {
        return UnitOfMeasure.ordering[tag]
    }
}

/**
 * The table view delegate that manages the table of invoice items on new invoice view
 */
class ItemsTableViewDelegate: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    let itemsTableView: NSTableView
    var items = [InvoiceItem]()
    let vatRateInteractor: VatRateInteractor
    
    init(itemsTableView: NSTableView, vatRateInteractor: VatRateInteractor) {
        self.itemsTableView = itemsTableView
        self.vatRateInteractor = vatRateInteractor
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
            text = item.amount.formatDecimal()
            cellIdentifier = CellIdentifiers.amountCell
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
            if let index = (self.vatRateInteractor.getVatRates().index {vr in vr.literal == item.vatRate.literal}) {
                cell.selectItem(at: index)
            } else {
                // exceptionally add vat rate which does not exist in settings anymore
                cell.addItem(withTitle: item.vatRate.literal)
                cell.selectItem(withTitle: item.vatRate.literal)
            }
            cell.tag = row
            return cell
        } else if tableColumn == tableView.tableColumns[5] {
            text = item.netValue.formatAmount()
            cellIdentifier = CellIdentifiers.netValueCell
        } else if tableColumn == tableView.tableColumns[6] {
            text = item.grossValue.formatAmount()
            cellIdentifier = CellIdentifiers.grossValueCell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}

/**
 * The extension that provides method for manipulating with the invoices table view
 */
extension ItemsTableViewDelegate {
    
    func changeItemName(_ sender: NSTextField) {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withName(sender.stringValue).build()
        }
    }
    
    func changeItemNetValue(_ sender: NSTextField) throws {
        let netValue = sender.stringValue.replacingOccurrences(of: ",", with: ".")
        guard let unitNetPrice = Decimal(string: netValue) else {
            throw InputValidationError.invalidNumber(fieldName: "Cena netto")
        }
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            let oldItem = items[selectedRowNumber]
            items[selectedRowNumber] = anInvoiceItem().from(source: oldItem).withUnitNetPrice(unitNetPrice).build()
        }
    }
    
    func changeAmount(_ sender: NSTextField) throws {
        let amountString = sender.stringValue.replacingOccurrences(of: ",", with: ".")
        guard let amount = Decimal(string: amountString) else {
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
        let defaultVatRate = self.vatRateInteractor.getDefaultVatRate()
        items.append(anInvoiceItem().withVatRate(defaultVatRate ?? VatRate(value: Decimal())).withUnitOfMeasure(.pieces).build())
    }
    
    func addItem(itemDefinition: ItemDefinition) {
        items.append(anInvoiceItem()
            .withName(itemDefinition.name)
            .withUnitNetPrice(itemDefinition.unitNetPrice)
            .withVatRate(itemDefinition.vatRate)
            .withUnitOfMeasure(itemDefinition.unitOfMeasure)
            .build())
    }
    
    func getSelectedItem() -> InvoiceItem? {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            return items[selectedRowNumber]
        }
        return nil
    }
    
    func removeSelectedItem() {
        let selectedRowNumber = itemsTableView.selectedRow
        if selectedRowNumber != -1 {
            items.remove(at: selectedRowNumber)
        }
    }
    
    func changeVatRate(row: Int, vatRate: VatRate) {
        let oldItem = items[row]
        items[row] = anInvoiceItem().from(source: oldItem).withVatRate(vatRate).build()
    }
}
