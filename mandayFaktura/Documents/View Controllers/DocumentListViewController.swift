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
    static let INVOICE_TO_PRINT_NOTIFICATION = Notification.Name(rawValue: "InvoiceToPrint")
    static let CREDIT_NOTE_NOTIFICATION = Notification.Name(rawValue: "InvoiceToCorrect")

    static let INVOICE_NOTIFICATION_KEY = "invoice"
}

class DocumentListViewController: NSViewController {
    @IBOutlet weak var invoiceHistoryTableView: NSTableView!
    var documentListTableViewDelegate: DocumentListTableViewDelegate?
    var invoiceFacade: InvoiceFacade?
    var creditNoteFacade: CreditNoteFacade?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeRepositories()
        
        self.invoiceFacade = InvoiceFacade()
        self.creditNoteFacade = CreditNoteFacade()
        documentListTableViewDelegate = DocumentListTableViewDelegate(invoiceFacade: self.invoiceFacade!, creditNoteFacade: self.creditNoteFacade!)
        invoiceHistoryTableView.delegate = documentListTableViewDelegate
        invoiceHistoryTableView.dataSource = documentListTableViewDelegate
        
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
        NotificationCenter.default.addObserver(forName: CreditNoteViewControllerConstants.CREDIT_NOTE_CREATED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in
                                                self.invoiceHistoryTableView.reloadData()
        }
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.INVOICE_TO_REMOVE_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.deleteDocument()}
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.INVOICE_TO_EDIT_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.editInvoice()}
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.CREDIT_NOTE_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.correctInvoice()}
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.INVOICE_TO_PRINT_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.printInvoice()}
    }
    
    func initializeRepositories() {
        CounterpartyRepositoryFactory.register(repository: KeyedArchiverCounterpartyRepository())
        InvoiceRepositoryFactory.register(repository: KeyedArchiverInvoiceRepository())
        ItemDefinitionRepositoryFactory.register(repository: KeyArchiverItemDefinitionRepository())
        InvoiceNumberingSettingsRepositoryFactory.register(repository: KeyedArchiverInvoiceNumberingSettingsRepository())
        VatRateRepositoryFactory.register(repository: KeyArchiverVatRateRepository())
        InvoiceSettingsRepositoryFactory.register(repository: KeyedArchiverInvoiceSettingsRepository())
        CreditNoteRepositoryFactory.register(repository: KeyedArchiverCreditNoteRepository())
    }
    
   
    fileprivate func getSelectedDocument() -> Document {
        return (self.documentListTableViewDelegate?.getSelectedDocument(index: invoiceHistoryTableView.selectedRow))!
    }
    
    func deleteDocument() {
        let alert = NSAlert()
        alert.messageText = "Usunięcie Dokumentu!"
        alert.informativeText = "Dane faktury zostaną utracone bezpowrotnie. Czy na pewno chcesz usunąć fakturę?"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Usuń")
        alert.addButton(withTitle: "Anuluj")
        let modalResponse = alert.runModal()
        if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
            let document = getSelectedDocument()
            if document is Invoice {
                invoiceFacade!.delete(document as! Invoice)
            } else if document is CreditNote {
                creditNoteFacade!.delete(document as! CreditNote)
            }
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
        alert.addButton(withTitle: "Anuluj")
        let modalResponse = alert.runModal()
        if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
            performSegue(withIdentifier: NSStoryboardSegue.Identifier("editInvoiceSegue"), sender: nil)
        } else if modalResponse == NSApplication.ModalResponse.alertThirdButtonReturn {
            return
        }
    }
    
    func correctInvoice() {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier("creditNoteSegue"), sender: nil)
    }
    
    func printInvoice() {
        let pdfDocument = getPdfDocument()!
        let pdfPrintOperation = PdfDocumentPrintOperation(document: pdfDocument.getDocument())
        pdfPrintOperation.runModal(on: self)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func getPdfDocument() -> PdfDocument? {
        let document: Document = getSelectedDocument()
        if document is Invoice {
            return InvoicePdfDocument(invoice: document as! Invoice)
        } else if document is CreditNote {
            return CreditNotePdfDocument(creditNote: document as! CreditNote)
        }
        return nil
    }
    
    @IBAction func onInvoiceHistoryTableViewClicked(_ sender: NSTableView) {
        let document: Document? = sender.selectedRow != -1 ? getSelectedDocument() : nil
        let invoiceDataDict:[String: Any] = [ViewControllerConstants.INVOICE_NOTIFICATION_KEY: document as Any]
        NotificationCenter.default.post(name: ViewControllerConstants.INVOICE_SELECTED_NOTIFICATION, object: nil, userInfo: invoiceDataDict)
    }
    
    @objc func onTableViewClicked(sender: AnyObject) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier("showPdfViewSegue"), sender: sender)
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is PdfViewController {
            let vc = segue.destinationController as? PdfViewController
            let pdfDocument = getPdfDocument()!
            vc?.pdfDocument = pdfDocument
        } else if segue.destinationController is EditInvoiceViewController {
            let vc = segue.destinationController as? EditInvoiceViewController
            let index = self.invoiceHistoryTableView.selectedRow
            vc?.invoice = documentListTableViewDelegate?.getSelectedDocument(index: index) as? Invoice
        } else if segue.destinationController is CreditNoteViewController {
            let vc = segue.destinationController as? CreditNoteViewController
            let index = self.invoiceHistoryTableView.selectedRow
            vc?.invoice = documentListTableViewDelegate?.getSelectedDocument(index: index) as? Invoice
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
        return self.invoiceHistoryTableView.selectedRow != -1
    }
}

