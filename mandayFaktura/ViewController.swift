//
//  ViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.01.2018.
//  Licensed under the MIT License. See LICENSE file for more details
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var invoiceHistoryTableView: NSTableView!
    let invoiceHistoryDataSourceController = InvoiceHistoryDataSourceController()
    override func viewDidLoad() {
        super.viewDidLoad()
        invoiceHistoryTableView.delegate = invoiceHistoryDataSourceController
        invoiceHistoryTableView.dataSource = invoiceHistoryDataSourceController
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

