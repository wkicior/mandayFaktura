//
//  InvoicePdfPage.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz


class InvoicePdfPage: BasePDFPage {
    let invoice: Invoice
    let copyLabel: String

    init(invoice: Invoice, copyLabel: String) {
        self.invoice = invoice
        self.copyLabel = copyLabel
        super.init()
    }
    
    func drawInvoiceHeader()  {
        pageLayout.drawInvoiceHeader(header: invoice.printedHeader)
        pageLayout.drawInvoiceHeaderDates(dates: invoice.printedDates)
    }
    
    func drawCopyLabel() {
        pageLayout.drawCopyLabel(label: self.copyLabel)
    }
    
    func drawSeller() {
        pageLayout.drawSeller(seller: invoice.seller.printedSeller)
    }
    
    func drawBuyer() {
        pageLayout.drawBuyer(buyer: invoice.buyer.printedBuyer)
    }
    
    func drawItemsTable() {
        var itemTableData: [[String]] = []
        for itemCounter in 0 ..< self.invoice.items.count {
            let properties = [(itemCounter + 1).description] + self.invoice.items[itemCounter].propertiesForDisplay
            itemTableData.append(properties)
        }
        pageLayout.drawItemsTable(headerData: InvoiceItem.itemColumnNames, tableData: itemTableData)
    }
    
    func drawItemsSummary() {
        pageLayout.drawItemsSummary(summaryData: ["Razem:"] + self.invoice.propertiesForDisplay)
    }
    
    func drawVatBreakdown() {
        var breakdownTableData: [[String]] = []
        for breakdownIndex in 0 ..< self.invoice.vatBreakdown.entries.count {
           let breakdown = self.invoice.vatBreakdown.entries[breakdownIndex]
            breakdownTableData.append(breakdown.propertiesForDisplay)
        }
        pageLayout.drawVatBreakdown(breakdownLabel: "W tym:", breakdownTableData: breakdownTableData)
    }
    
    func drawPaymentSummary() {
        pageLayout.drawPaymentSummary(content: invoice.printedPaymentSummary)
    }
    
    func drawNotes() {
        pageLayout.drawNotes(content: invoice.notes)
    }
    
    override func draw(with box: PDFDisplayBox) {
        self.drawInvoiceHeader()
        self.drawCopyLabel()
        self.drawSeller()
        self.drawBuyer()
        self.drawItemsTable()
        self.drawItemsSummary()
        self.drawVatBreakdown()
        self.drawPaymentSummary()
        self.drawNotes()
    }
}
