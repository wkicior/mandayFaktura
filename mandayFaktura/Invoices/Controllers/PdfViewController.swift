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
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileUrl:URL? = Bundle.main.url(forResource: "Invoice", withExtension: "pdf")
        let doc = PDFDocument(url: fileUrl!)
        pdfView.document = doc
        // Do view setup here.
    }
    
}
