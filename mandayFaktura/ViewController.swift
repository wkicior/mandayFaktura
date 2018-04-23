//
//  ViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.01.2018.
//  Licensed under the MIT License. See LICENSE file for more details
//

import Cocoa

struct ViewControllerConstants {
    static let INVOICE_SELECTED_NOTIFICATION = Notification.Name(rawValue: "InvoiceSelected")
    static let INVOICE_TO_REMOVE_NOTIFICATION = Notification.Name(rawValue: "InvoiceToRemove")
    static let INVOICE_TO_EDIT_NOTIFICATION = Notification.Name(rawValue: "InvoiceToEdit")

    static let INVOICE_NOTIFICATION_KEY = "invoice"
}

class ViewController: NSViewController {
    var invoiceRepository:InvoiceRepository?
    @IBOutlet weak var invoiceHistoryTableView: NSTableView!
    var invoiceHistoryTableViewDelegate:InvoiceHistoryTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CounterpartyRepositoryFactory.register(repository: KeyedArchiverCounterpartyRepository())
        InvoiceRepositoryFactory.register(repository: KeyedArchiverInvoiceRepository())
        ItemDefinitionRepositoryFactory.register(repository: KeyArchiverItemDefinitionRepository())
        InvoiceNumberingSettingsRepositoryFactory.register(repository: KeyedArchiverInvoiceNumberingSettingsRepository())
        invoiceHistoryTableViewDelegate = InvoiceHistoryTableViewDelegate()
        invoiceHistoryTableView.delegate = invoiceHistoryTableViewDelegate
        invoiceHistoryTableView.dataSource = invoiceHistoryTableViewDelegate
        
        invoiceHistoryTableView.doubleAction = #selector(onTableViewClicked)
        
        NotificationCenter.default.addObserver(forName: NewInvoiceViewControllerConstants.INVOICE_ADDED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in
                                                self.invoiceHistoryTableView.reloadData()
        }
        NotificationCenter.default.addObserver(forName: EditInvoiceViewControllerConstants.INVOICE_EDITED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in
                                                self.invoiceHistoryTableView.reloadData()
        }
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.INVOICE_TO_REMOVE_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.deleteInvoice()}
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.INVOICE_TO_EDIT_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.editInvoice()}
        invoiceRepository = InvoiceRepositoryFactory.instance
    }
    
   
    func deleteInvoice() {
        let alert = NSAlert()
        alert.messageText = "Usunięcie faktury!"
        alert.informativeText = "Dane faktury zostaną utracone bezpowrotnie. Czy na pewno chcesz usunąć fakturę?"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Usuń")
        alert.addButton(withTitle: "Nie usuwaj")
        let modalResponse = alert.runModal()
        if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
            invoiceRepository!.delete((self.invoiceHistoryTableViewDelegate?.getSelectedInvoice(index: invoiceHistoryTableView.selectedRow))!)
            self.invoiceHistoryTableView.reloadData()
        } else if modalResponse == NSApplication.ModalResponse.alertThirdButtonReturn {
           return
        }
    }
    
    func editInvoice() {
        let alert = NSAlert()
        alert.messageText = "Edycja faktury!"
        alert.informativeText = "Dane faktury mogą zostać nadpisane. Czy na pewno chcesz edytować fakturę?"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Edytuj")
        alert.addButton(withTitle: "Zamknij")
        let modalResponse = alert.runModal()
        if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
            performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "editInvoiceSegue"), sender: nil)
        } else if modalResponse == NSApplication.ModalResponse.alertThirdButtonReturn {
            return
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func onInvoiceHistoryTableViewClicked(_ sender: NSTableView) {
        let invoice: Invoice? = sender.selectedRow != -1 ? invoiceHistoryTableViewDelegate?.getSelectedInvoice(index: sender.selectedRow): nil
        let invoiceDataDict:[String: Any] = [ViewControllerConstants.INVOICE_NOTIFICATION_KEY: invoice as Any]
        NotificationCenter.default.post(name: ViewControllerConstants.INVOICE_SELECTED_NOTIFICATION, object: nil, userInfo: invoiceDataDict)
    }
    
    @objc func onTableViewClicked(sender: AnyObject) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "showPdfViewSegue"), sender: sender)
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is PdfViewController {
            let vc = segue.destinationController as? PdfViewController
            let index = self.invoiceHistoryTableView.selectedRow
            vc?.invoice = invoiceHistoryTableViewDelegate?.getSelectedInvoice(index: index)
        } else if segue.destinationController is EditInvoiceViewController {
            let vc = segue.destinationController as? EditInvoiceViewController
            let index = self.invoiceHistoryTableView.selectedRow
            vc?.invoice = invoiceHistoryTableViewDelegate?.getSelectedInvoice(index: index)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
        return self.invoiceHistoryTableView.selectedRow != -1
    }
}

