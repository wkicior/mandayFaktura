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
    var invoiceHistoryTableViewDelegate:InvoiceHistoryTableViewDelegate?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        CounterpartyRepositoryFactory.register(repository: KeyedArchiverCounterpartyRepository())
        InvoiceRepositoryFactory.register(repository: KeyedArchiverInvoiceRepository())
        ItemDefinitionRepositoryFactory.register(repository: KeyArchiverItemDefinitionRepository())
        invoiceHistoryTableViewDelegate = InvoiceHistoryTableViewDelegate()
        invoiceHistoryTableView.delegate = invoiceHistoryTableViewDelegate
        invoiceHistoryTableView.dataSource = invoiceHistoryTableViewDelegate
        
        invoiceHistoryTableView.doubleAction = #selector(onTableViewClicked)
        
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
    
    @objc func onTableViewClicked(sender: AnyObject) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "showPdfViewSegue"), sender: sender)
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is PdfViewController {
            let vc = segue.destinationController as? PdfViewController
            let index = self.invoiceHistoryTableView.selectedRow
            vc?.invoice = invoiceHistoryTableViewDelegate?.getSelectedInvoice(index: index)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
        return self.invoiceHistoryTableView.selectedRow != -1
    }
}

