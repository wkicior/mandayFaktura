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
    
    var invoice: Invoice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let invoicePdf = InvoicePdf(invoice: self.invoice!)
        pdfView.document = invoicePdf.getDocument()
    }
    
}
