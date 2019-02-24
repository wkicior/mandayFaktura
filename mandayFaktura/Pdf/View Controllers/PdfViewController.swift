//
//  PdfViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 28.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa
import Quartz

class PdfViewController: NSViewController {

    @IBOutlet weak var pdfView: PDFView!
    var pdfDocument: PdfDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pdfView.document = pdfDocument!.getDocument()
    }
    
    @IBAction func onPrintButtonClicked(_ sender: NSButton) {
        let pdfPrintOperation = PdfDocumentPrintOperation(document: pdfView.document!)
        pdfPrintOperation.runModal(on: self)
    }
    
    @IBAction func onExportButtonClicked(_ sender: NSButton) {
        let homeDirURL = FileManager.default.homeDirectoryForCurrentUser
        self.pdfDocument!.save(dir: homeDirURL)
    }
}
