//
//  PdfInvoice.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz



class InvoicePdf {
    let invoice: Invoice
    
    init(invoice: Invoice) {
        self.invoice = invoice
    }
    
    func getDocument() -> PDFDocument {       
        let doc = PDFDocument()
        let invoicePage = InvoicePdfPage(invoice: self.invoice, pageNumber: 1)
        doc.insert(invoicePage, at: 0)
        return doc
    }
}
