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
    static let KSEF_NUMBER_NOTIFICATION = Notification.Name(rawValue: "KsefNumber")


    static let INVOICE_NOTIFICATION_KEY = "invoice"
}

class DocumentListViewController: NSViewController {
    @IBOutlet weak var invoiceHistoryTableView: NSTableView!
    var documentListTableViewDelegate: DocumentListTableViewDelegate?
    var invoiceFacade: InvoiceFacade?
    var creditNoteFacade: CreditNoteFacade?
    var invoiceSettingsFacade: InvoiceSettingsFacade?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeRepositories()
        
        self.invoiceFacade = InvoiceFacade()
        self.creditNoteFacade = CreditNoteFacade()
        self.invoiceSettingsFacade = InvoiceSettingsFacade()
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
                                                (notification) in self.deleteDocumentIfHasNoCreditNote()}
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.INVOICE_TO_EDIT_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.editInvoiceIfHasNoCreditNote()}
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.CREDIT_NOTE_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.correctInvoice()}
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.INVOICE_TO_PRINT_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.printInvoice()}
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.KSEF_NUMBER_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.ksefNumberEdit()}
    }
    
    func initializeRepositories() {
        CounterpartyRepositoryFactory.register(repository: KeyedArchiverCounterpartyRepository())
        InvoiceRepositoryFactory.register(repository: KeyedArchiverInvoiceRepository())
        ItemDefinitionRepositoryFactory.register(repository: KeyArchiverItemDefinitionRepository())
        InvoiceNumberingSettingsRepositoryFactory.register(repository: KeyedArchiverInvoiceNumberingSettingsRepository())
        VatRateRepositoryFactory.register(repository: KeyArchiverVatRateRepository())
        InvoiceSettingsRepositoryFactory.register(repository: KeyedArchiverInvoiceSettingsRepository())
        CreditNoteRepositoryFactory.register(repository: KeyedArchiverCreditNoteRepository())
        CreditNoteNumberingSettingsRepositoryFactory.register(repository: KeyedArchiverCreditNoteNumberingSettingsRepository())
    }
    
   
    fileprivate func getSelectedDocument() -> Document {
        return (self.documentListTableViewDelegate?.getSelectedDocument(index: invoiceHistoryTableView.selectedRow))!
    }
    
    func deleteDocumentIfHasNoCreditNote() {
        let index = self.invoiceHistoryTableView.selectedRow
        let document = documentListTableViewDelegate?.getSelectedDocument(index: index)
        if let creditNote = creditNoteFacade!.creditNoteForInvoice(invoiceNumber: document!.number) {
            let alert = NSAlert()
            if #available(macOS 12, *) {
                alert.messageText = String(localized: "DOCUMENT_REMOVAL", defaultValue: "Document removal!")
                alert.informativeText = "\(String(localized: "DOCUMENT_HAS_CREDIT_NOTE", defaultValue: "The document has the credit note assigned")) \(creditNote.number) \(String(localized: "DOCUMENT_COULD_NOT_BE_REMOVED", defaultValue: "and therefore could not be removed"))"
            } else {
                alert.messageText = "Usunięcie dokumentu!"
                alert.informativeText = "Dokument ma przypisaną fakturę korygującą \(creditNote.number) i nie może zostać usunięty"
            }
            alert.alertStyle = .critical
            alert.runModal()
        } else {
            deleteDocument()
        }
    }
    
    func deleteDocument() {
        let alert = NSAlert()
        if #available(macOS 12, *) {
            alert.messageText = String(localized: "DOCUMENT_REMOVAL", defaultValue: "Document removal!")
            alert.informativeText = String(localized: "IRRETRIEVABLY_DELETED", defaultValue: "The invoice will be irretrievably deleted. Are you sure you want to delete the invoice?")
            alert.addButton(withTitle: String(localized: "DELETE", defaultValue: "Delete"))
            alert.addButton(withTitle: String(localized: "CANCEL", defaultValue: "Anuluj"))
        } else {
            alert.messageText = "Usunięcie dokumentu!"
            alert.informativeText = "Dane faktury zostaną utracone bezpowrotnie. Czy na pewno chcesz usunąć fakturę?"
            alert.addButton(withTitle: "Usuń")
            alert.addButton(withTitle: "Anuluj")
        }
        alert.alertStyle = .warning
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
    
    func editInvoiceIfHasNoCreditNote() {
        let index = self.invoiceHistoryTableView.selectedRow
        let invoice = documentListTableViewDelegate?.getSelectedDocument(index: index) as? Invoice
        if let creditNote = creditNoteFacade!.creditNoteForInvoice(invoiceNumber: invoice!.number) {
            let alert = NSAlert()
            if #available(macOS 12, *) {
                alert.messageText = String(localized: "INVOICE_EDIT", defaultValue: "Editing invoice!")
                alert.informativeText = "\(String(localized: "DOCUMENT_HAS_CREDIT_NOTE", defaultValue: "The document has the credit note assigned")) \(creditNote.number) \(String(localized: "DOCUMENT_COULD_NOT_BE_EDITED", defaultValue: "and therefore could not be edited"))"
            } else {
                alert.messageText = "Edycja faktury!"
                alert.informativeText = "Faktura ma przypisaną fakturę korygującą \(creditNote.number) i nie może już być edytowana"
            }
            alert.alertStyle = .critical
            alert.runModal()
        } else {
            editInvoice()
        }
    }
    
    func editInvoice() {
        let alert = NSAlert()
        if #available(macOS 12, *) {
            alert.messageText = String(localized: "INVOICE_EDIT", defaultValue: "Editing invoice!")
            alert.informativeText = String(localized: "CONFIRM_INVOICE_EDIT", defaultValue: "Invoice data will be overwriten. Are you sure you want to continue?")
            alert.addButton(withTitle: String(localized: "EDIT", defaultValue: "Edit"))
            alert.addButton(withTitle: String(localized: "CANCEL", defaultValue: "Anuluj"))

        } else {
            alert.messageText = "Edycja faktury!"
            alert.informativeText = "Dane faktury mogą zostać nadpisane. Czy na pewno chcesz edytować fakturę?"
            alert.addButton(withTitle: "Edytuj")
            alert.addButton(withTitle: "Anuluj")
        }
        alert.alertStyle = .warning
        let modalResponse = alert.runModal()
        if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
            performSegue(withIdentifier: NSStoryboardSegue.Identifier("editInvoiceSegue"), sender: nil)
        } else if modalResponse == NSApplication.ModalResponse.alertThirdButtonReturn {
            return
        }
    }
    
    func correctInvoice() {
        let index = self.invoiceHistoryTableView.selectedRow
        let invoice = documentListTableViewDelegate?.getSelectedDocument(index: index) as? Invoice
        if let creditNote = creditNoteFacade!.creditNoteForInvoice(invoiceNumber: invoice!.number) {
            let alert = NSAlert()
            if #available(macOS 12, *) {
                alert.messageText = String(localized: "CREDIT_NOTE_CREATION", defaultValue: "Credit note creation!")
                alert.informativeText = "\(String(localized: "DOCUMENT_HAS_CREDIT_NOTE", defaultValue: "The document has the credit note assigned")) \(creditNote.number)"

            } else {
                alert.messageText = "Korekta faktury!"
                alert.informativeText = "Faktura ma przypisaną fakturę korygującą \(creditNote.number)"
            }
           
            alert.alertStyle = .critical
            alert.runModal()
        } else {
            performSegue(withIdentifier: NSStoryboardSegue.Identifier("creditNoteSegue"), sender: nil)
        }
    }
    
    func printInvoice() {
        let pdfDocument = getPdfDocument()!
        let pdfPrintOperation = PdfDocumentPrintOperation(document: pdfDocument.getDocument())
        pdfPrintOperation.runModal(on: self)
    }
    
    func ksefNumberEdit() {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier("ksefNumberSegue"), sender: nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func getPdfDocument() -> PdfDocument? {
        let document: Document = getSelectedDocument()
        let invoiceSettings: InvoiceSettings = self.invoiceSettingsFacade?.getInvoiceSettings() ?? InvoiceSettings(paymentDateDays: 14)
        if document is Invoice {
            return InvoicePdfDocument(invoice: document as! Invoice, invoiceSettings: invoiceSettings)
        } else if document is CreditNote {
            return CreditNotePdfDocument(creditNote: document as! CreditNote, invoiceSettings: invoiceSettings)
        }
        return nil
    }
    
    private func getKsefXml() -> KsefXml? {
        let document: Document = getSelectedDocument()
        if document is Invoice {
            return KsefXml(invoice: document as! Invoice)
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
        if segue.destinationController is ViewInvoiceController {
            let vc = segue.destinationController as? ViewInvoiceController
            vc?.pdfDocument = getPdfDocument()!
            vc?.ksefXml = getKsefXml()
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

