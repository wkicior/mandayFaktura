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
    
    init(creditNote: CreditNote) {
        self.document = creditNote
    }
    
    func getDocumentPageDistribution(_ copy: CopyTemplate) -> DocumentPageDistribution {
        return CreditNotePageDistribution(copyTemplate: copy, creditNote: self.document as! CreditNote)
    }
}
