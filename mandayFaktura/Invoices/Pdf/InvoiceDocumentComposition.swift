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
    
    fileprivate func getInvoicePagesForCopy(_ copy: CopyTemplate) -> [InvoicePdfPage] {
        let invoicePageComposition = anInvoicePageComposition()
            .withHeader(invoice.printedHeader)
            .withDates(invoice.printedDates)
            .withCopyLabel(copy.rawValue)
            .withSeller(invoice.seller.printedSeller)
            .withBuyer(invoice.buyer.printedBuyer)
            .withItemTableData(getItemTableData())
            .withItemsSummary(invoice.propertiesForDisplay)
            .withVatBreakdownTableData(getVatBreakdownTableData())
            .withPaymentSummary(invoice.printedPaymentSummary)
            .withNotes(invoice.notes)
            .build()
        return [InvoicePdfPage(invoice: self.invoice, pageComposition: invoicePageComposition)]
    }
    
    func getVatBreakdownTableData() -> [[String]] {
        var breakdownTableData: [[String]] = []
        for breakdownIndex in 0 ..< self.invoice.vatBreakdown.entries.count {
            let breakdown = self.invoice.vatBreakdown.entries[breakdownIndex]
            breakdownTableData.append(breakdown.propertiesForDisplay)
        }
        return breakdownTableData
    }
    
    func getItemTableData() -> [[String]] {
        var itemTableData: [[String]] = []
        for itemCounter in 0 ..< self.invoice.items.count {
            let properties = [(itemCounter + 1).description] + self.invoice.items[itemCounter].propertiesForDisplay
            itemTableData.append(properties)
        }
        return itemTableData
    }
    
    func getInvoicePages(copies: [CopyTemplate]) -> [InvoicePdfPage] {
        return copies.flatMap({copy in getInvoicePagesForCopy(copy)})
    }
}

