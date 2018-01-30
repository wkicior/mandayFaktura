//
//  PdfInvoice.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz

class PdfInvoice {
    func getDocument() -> PDFDocument {
        let fileUrl:URL? = Bundle.main.url(forResource: "Invoice", withExtension: "pdf")
        let doc = PDFDocument(url: fileUrl!)
        return doc!
    }
}
