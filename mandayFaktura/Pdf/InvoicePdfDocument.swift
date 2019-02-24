//
//  InvoicePdf.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz

class InvoicePdfDocument: PdfDocument{
    let document: Document
    
    init(invoice: Invoice) {
        self.document = invoice
    }
    
    func getDocumentPageDistribution(_ copy: CopyTemplate) -> DocumentPageDistribution {
        return InvoicePageDistribution(copyTemplate: copy, invoice: self.document as! Invoice)
    }
}
