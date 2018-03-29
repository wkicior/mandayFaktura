//
//  InvoicePdf.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz

enum CopyTemplate: String {
    case original = "oryginał", copy = "kopia"
}

class InvoicePdf {
    let invoice: Invoice
    
    init(invoice: Invoice) {
        self.invoice = invoice
    }
    
    func getDocument() -> PDFDocument {       
        let doc = PDFDocument()
        let invoicePage = InvoicePdfPage(invoice: self.invoice, copyLabel: CopyTemplate.original.rawValue)
        let invoicePage2 = InvoicePdfPage(invoice: self.invoice, copyLabel: CopyTemplate.copy.rawValue)

        doc.insert(invoicePage, at: 0)
        doc.insert(invoicePage2, at: 1)
        
        return doc
    }
    
    func getDocument(copyTemplate: CopyTemplate) -> PDFDocument {
        let doc = PDFDocument()
        let invoicePage = InvoicePdfPage(invoice: self.invoice, copyLabel: copyTemplate.rawValue)
        doc.insert(invoicePage, at: 0)
        return doc
    }
}
