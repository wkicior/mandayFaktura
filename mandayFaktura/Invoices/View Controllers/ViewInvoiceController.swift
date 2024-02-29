//
//  PdfViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 28.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa
import Quartz

class ViewInvoiceController: NSViewController {

    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var exportPdfButton: NSButtonCell!
    var pdfDocument: PdfDocument?
    var ksefXml: KsefXml?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(macOS 12, *) {
            self.exportPdfButton.title = String(localized: "EXPORT_TO_PDF", defaultValue: "Eksportuj do PDF")
        } else {
            self.exportPdfButton.title = "Eksportuj do PDF"
        }
        pdfView.document = pdfDocument!.getDocument()
    }
    
    @IBAction func onPrintButtonClicked(_ sender: NSButton) {
        let pdfPrintOperation = PdfDocumentPrintOperation(document: pdfView.document!)
        pdfPrintOperation.runModal(on: self)
    }
    
    @IBAction func onPdfExportButtonClicked(_ sender: NSButton) {
        do {
            let homeDirURL = FileManager.default.homeDirectoryForCurrentUser
            self.pdfDocument!.save(dir: homeDirURL)
        } catch let error as Error {
            WarningAlert(warning: "Nie udalo sie zapisac PDF", text: error.localizedDescription).runModal()
        }
    }
    
    @IBAction func onXmlExportButtonClicked(_ sender: NSButton) {
        do {
            let homeDirURL = FileManager.default.homeDirectoryForCurrentUser
            try self.ksefXml!.save(dir: homeDirURL)
        } catch let error as Error{
            WarningAlert(warning: "Nie udalo sie zapisac XML", text: error.localizedDescription).runModal()
        }
    }
}
