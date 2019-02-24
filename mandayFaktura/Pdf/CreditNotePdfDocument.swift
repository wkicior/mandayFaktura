//
//  CreditNotePdfDocument.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 24.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz

class CreditNotePdfDocument: PdfDocument {
    let creditNote: CreditNote
    
    init(creditNote: CreditNote) {
        self.creditNote = creditNote
    }
    
    func getDocument() -> PDFDocument {
        let doc = PDFDocument()
        for (index, element) in self.getInvoicePages(copies: [CopyTemplate.original, CopyTemplate.copy]).enumerated() {
            doc.insert(element, at: index)
        }
        
        return doc
    }
    
    func save(dir: URL) {
        let original = self.getDocument(copyTemplate: .original)
        original.write(toFile: "\(dir.path)/Downloads/\(self.creditNote.number.encodeToFilename)-org.pdf")
        let copy = self.getDocument(copyTemplate: .copy)
        copy.write(toFile: "\(dir.path)/Downloads/\(self.creditNote.number.encodeToFilename)-kopia.pdf")
    }
    
    func getInvoicePages(copies: [CopyTemplate]) -> [DocumentPdfPage] {
        return copies.flatMap({copy in getInvoicePagesForCopy(copy)})
    }
    
    fileprivate func getInvoicePagesForCopy(_ copy: CopyTemplate) -> [DocumentPdfPage] {
        let invoicePageDistribution = CreditNotePageDistribution(copyTemplate: copy, creditNote: self.creditNote)
        return invoicePageDistribution.distributeInvoiceOverPageCompositions()
            .map({pageComposition in DocumentPdfPage(pageComposition: pageComposition)})
    }
    
    private func getDocument(copyTemplate: CopyTemplate) -> PDFDocument {
        let doc = PDFDocument()
        for (index, element) in self.getInvoicePages(copies: [CopyTemplate.original]).enumerated() {
            doc.insert(element, at: index)
        }
        return doc
    }
}
