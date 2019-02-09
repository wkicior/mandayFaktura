//
//  InvoiceDocumentComposition.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation


class InvoiceDocumentComposition {
    let invoice:Invoice


    init(invoice: Invoice) {
        self.invoice = invoice
    }

    func getInvoicePages(copies: [CopyTemplate]) -> [InvoicePdfPage] {
        return copies.flatMap({copy in getInvoicePagesForCopy(copy)})
    }
    
    fileprivate func getInvoicePagesForCopy(_ copy: CopyTemplate) -> [InvoicePdfPage] {
        let invoicePageDistribution = InvoicePageDistribution(copyTemplate: copy, invoice: self.invoice)
        return invoicePageDistribution.distributeInvoiceOverPageCompositions()
            .map({pageComposition in InvoicePdfPage(pageComposition: pageComposition)})
    }
}

