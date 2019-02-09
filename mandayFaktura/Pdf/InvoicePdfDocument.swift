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

class InvoicePdfDocument {
    let invoice: Invoice
    let invoiceDocumentComposition: InvoiceDocumentComposition
    
    init(invoice: Invoice) {
        self.invoice = invoice
        self.invoiceDocumentComposition = InvoiceDocumentComposition(invoice: invoice)
    }
    
    func getDocument() -> PDFDocument {       
        let doc = PDFDocument()
        for (index, element) in self.invoiceDocumentComposition.getInvoicePages(copies: [CopyTemplate.original, CopyTemplate.copy]).enumerated() {
            doc.insert(element, at: index)
        }
    
        return doc
    }
    
    func getDocument(copyTemplate: CopyTemplate) -> PDFDocument {
        let doc = PDFDocument()
        for (index, element) in self.invoiceDocumentComposition.getInvoicePages(copies: [CopyTemplate.original]).enumerated() {
            doc.insert(element, at: index)
        }
        return doc
    }
}
