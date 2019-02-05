//
//  InvoicePdfPage.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz


class InvoicePdfPage: PDFPage {
    let pageComposition: InvoicePageComposition

    init(pageComposition: InvoicePageComposition) {
        self.pageComposition = pageComposition
        super.init()
    }
    
    override func bounds(for box: PDFDisplayBox) -> NSRect {
        //TODO: delegate to pageComposition?
        return NSMakeRect(0, 0, InvoicePageComposition.pdfWidth, InvoicePageComposition.pdfHeight)
    }
    
    override func draw(with box: PDFDisplayBox) {
        self.pageComposition.draw()
    }
}
