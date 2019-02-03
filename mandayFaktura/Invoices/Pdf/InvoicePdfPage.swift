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
    let pageComposition: InvoicePageComposition

    init(invoice: Invoice, pageComposition: InvoicePageComposition) {
        self.invoice = invoice
        self.pageComposition = pageComposition
        super.init()
    }
    
    func drawInvoiceHeader()  {
        pageLayout.drawInvoiceHeader(header: self.pageComposition.header)
        pageLayout.drawInvoiceHeaderDates(dates: self.pageComposition.dates)
    }
    
    func drawCopyLabel() {
        pageLayout.drawCopyLabel(label: self.pageComposition.copyLabel)
    }
    
    func drawSeller() {
        pageLayout.drawSeller(seller: self.pageComposition.seller)
    }
    
    func drawBuyer() {
        pageLayout.drawBuyer(buyer: self.pageComposition.buyer)
    }
    
    func drawItemsTable() {
        pageLayout.drawItemsTable(headerData: InvoiceItem.itemColumnNames, tableData: self.pageComposition.itemTableData)
    }
    
    func drawItemsSummary() {
        pageLayout.drawItemsSummary(summaryData: ["Razem:"] + self.pageComposition.itemsSummary)
    }
    
    func drawVatBreakdown() {
        pageLayout.drawVatBreakdown(breakdownLabel: "W tym:", breakdownTableData: self.pageComposition.vatBreakdownTableData)
    }
    
    func drawPaymentSummary() {
        pageLayout.drawPaymentSummary(content: self.pageComposition.paymentSummary)
    }
    
    func drawNotes() {
        pageLayout.drawNotes(content: self.pageComposition.notes)
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
