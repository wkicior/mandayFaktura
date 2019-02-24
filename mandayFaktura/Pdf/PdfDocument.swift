//
//  PdfDocument.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 24.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz

extension String {
    var encodeToFilename: String {
        get {
            return self.replacingOccurrences(of: "/", with: "-")
        }
    }
}

enum CopyTemplate: String {
    case original = "oryginał", copy = "kopia"
}

protocol PdfDocument {
    var document: Document { get }

    func getDocument() -> PDFDocument
    func save(dir: URL)
    
    func getDocumentPageDistribution(_ copy: CopyTemplate) -> DocumentPageDistribution
}

extension PdfDocument {
    
    func getDocument() -> PDFDocument {
        let doc = PDFDocument()
        for (index, element) in self.getDocumentPages().enumerated()  {
            doc.insert(element, at: index)
        }
        return doc
    }
    
    func getDocument(copyTemplate: CopyTemplate) -> PDFDocument {
        let doc = PDFDocument()
        for (index, element) in self.getDocumentPages().enumerated() {
            doc.insert(element, at: index)
        }
        return doc
    }
    
    func getDocumentPages() -> [DocumentPdfPage] {
        return [CopyTemplate.original, CopyTemplate.copy].flatMap({copy in getDocumentPagesForCopy(copy)})
    }
    
    func save(dir: URL) {
        let original = self.getDocument(copyTemplate: .original)
        original.write(toFile: "\(dir.path)/Downloads/\(self.document.number.encodeToFilename)-org.pdf")
        let copy = self.getDocument(copyTemplate: .copy)
        copy.write(toFile: "\(dir.path)/Downloads/\(self.document.number.encodeToFilename)-kopia.pdf")
    }
    
    func getDocumentPagesForCopy(_ copy: CopyTemplate) -> [DocumentPdfPage] {
        let creditNotePageDistribution = getDocumentPageDistribution(copy)
        return creditNotePageDistribution.distributeDocumentOverPageCompositions()
            .map({pageComposition in DocumentPdfPage(pageComposition: pageComposition)})
    }
}
