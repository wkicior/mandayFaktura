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
    let document: Document
    let invoiceSettings: InvoiceSettings

    
    init(creditNote: CreditNote, invoiceSettings: InvoiceSettings) {
        self.document = creditNote
        self.invoiceSettings = invoiceSettings
    }
    
    func getDocumentPageDistribution(_ copy: CopyTemplate) -> DocumentPageDistribution {
        return CreditNotePageDistribution(copyTemplate: copy, creditNote: self.document as! CreditNote, invoiceSettings: invoiceSettings)
    }
}
