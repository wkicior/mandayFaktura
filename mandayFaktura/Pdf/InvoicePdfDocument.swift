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
    let invoiceSettings: InvoiceSettings
    
    init(invoice: Invoice, invoiceSettings: InvoiceSettings) {
        self.document = invoice
        self.invoiceSettings = invoiceSettings
    }
    
    func getDocumentPageDistribution(_ copy: CopyTemplate) -> DocumentPageDistribution {
        return InvoicePageDistribution(copyTemplate: copy, invoice: self.document as! Invoice, invoiceSettings: self.invoiceSettings)
    }
}
