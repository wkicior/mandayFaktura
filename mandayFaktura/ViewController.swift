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
    var invoiceRepository:InvoiceRepository?
    var invoiceHistoryTableViewController:InvoiceHistoryTableViewController?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDel = NSApplication.shared.delegate as! AppDelegate
        invoiceRepository = appDel.invoiceRepository
        invoiceHistoryTableViewController = InvoiceHistoryTableViewController(invoiceRepository: invoiceRepository!)
        invoiceHistoryTableView.delegate = invoiceHistoryTableViewController
        invoiceHistoryTableView.dataSource = invoiceHistoryTableViewController
        
        NotificationCenter.default.addObserver(forName: NewInvoiceViewControllerConstants.INVOICE_ADDED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in
                                                self.invoiceHistoryTableView.reloadData()
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

