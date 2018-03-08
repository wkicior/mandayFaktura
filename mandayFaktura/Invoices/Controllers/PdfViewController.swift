//
//  PdfViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 28.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa
import Quartz

private extension String {
    var encodeToFilename: String {
        get {
            return self.replacingOccurrences(of: "/", with: "-")
        }
    }
}

class PdfViewController: NSViewController {

    @IBOutlet weak var pdfView: PDFView!
    
    var invoice: Invoice?
    var invoicePdf: InvoicePdf?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        invoicePdf = InvoicePdf(invoice: self.invoice!)
        pdfView.document = invoicePdf!.getDocument()
    }
    
    @IBAction func onPrintButtonClicked(_ sender: NSButton) {
        pdfView.document?.write(toFile: "/Users/disorder/Downloads/\(invoice?.number.encodeToFilename ?? "Faktura").pdf")
    }
}
