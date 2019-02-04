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
    let pageComposition: InvoicePageComposition

    init(pageComposition: InvoicePageComposition) {
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
        pageLayout.drawItemsTable(itemTableLayout: self.pageComposition.itemTableData)
    }
    
    func drawItemsSummary() {
        pageLayout.drawItemsSummary(summaryData: self.pageComposition.itemsSummary)
    }
    
    func drawVatBreakdown() {
        pageLayout.drawVatBreakdown(vatBreakdown: self.pageComposition.vatBreakdownTableData)
    }
    
    func drawPaymentSummary() {
        pageLayout.drawPaymentSummary(paymentSummary: self.pageComposition.paymentSummary)
    }
    
    func drawNotes() {
        pageLayout.drawNotes(notes: self.pageComposition.notes)
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
