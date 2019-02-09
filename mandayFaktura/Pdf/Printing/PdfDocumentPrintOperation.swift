//
//  InvoicePrintOperation.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 18.11.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa
import Quartz


class PdfDocumentPrintOperation {
    let document: PDFDocument
    let printOperation: NSPrintOperation
    
    init(document: PDFDocument) {
        self.document = document
        let printInfoDictionary = NSMutableDictionary(dictionary: NSPrintInfo.shared.dictionary())
        let printInfo = NSPrintInfo(dictionary: printInfoDictionary as! [NSPrintInfo.AttributeKey : Any])
        self.printOperation = self.document.printOperation(for: printInfo, scalingMode: .pageScaleToFit, autoRotate: false)!
    }
    
    func runModal(on: NSViewController) {
        self.printOperation.runModal(for: on.view.window!, delegate: on, didRun: nil, contextInfo: nil)
    }
}
