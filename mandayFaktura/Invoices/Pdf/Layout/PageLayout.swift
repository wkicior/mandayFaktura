//
//  PageLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 05.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz
import AppKit

class PageLayout {
    static let leftMargin = CGFloat(20.0)
    static let rightMargin = CGFloat(20.0)
    
    static let debug = false
    
    let pdfHeight = CGFloat(1024.0)
    static let pdfWidth = CGFloat(768.0)
    
    static let defaultRowHeight = CGFloat(14)
    static let gridPadding = CGFloat(5)
    private var breakdownItemsCount = 0
    
    private var itemsSummaryYPosition = CGFloat(0)
    
    func drawInvoiceHeader(header: HeaderLayout) {
        header.draw()
    }
    
    func drawCopyLabel(label: CopyLabelLayout) {
        label.draw()
    }
    
    func drawInvoiceHeaderDates(dates: HeaderInvoiceDatesLayout) {
        dates.draw()
    }
    
    func drawSeller(seller: SellerLayout) {
        seller.draw()
    }
    
    func drawBuyer(buyer: BuyerLayout) {
        buyer.draw()
    }
    
    func drawItemsTable(itemTableLayout: ItemTableLayout) {
        itemTableLayout.draw()
        self.itemsSummaryYPosition = itemTableLayout.itemsSummaryYPosition // TODO: clean this up
    }
    
    func drawItemsSummary(summaryData: ItemsSummaryLayout) {
        summaryData.draw(yPosition: self.itemsSummaryYPosition) //TODO: clean this up
        self.itemsSummaryYPosition = summaryData.yPosition
    }
    
    func drawVatBreakdown(vatBreakdown: VatBreakdownLayout) {
        vatBreakdown.draw(yPosition: self.itemsSummaryYPosition)
        self.breakdownItemsCount = vatBreakdown.breakdownItemsCount //TODO align to pixels
    }
    
    func drawPaymentSummary(paymentSummary: PaymentSummaryLayout) {
        paymentSummary.draw(yPosition: paymentSummaryYPosition)
    }
    
    func drawNotes(notes: NotesLayout) {
        notes.draw(yPosition: paymentSummaryYPosition - CGFloat(100.0))
    }
    
    private var paymentSummaryYPosition: CGFloat {
        get {
            return itemsSummaryYPosition - (CGFloat(self.breakdownItemsCount + 6) * (PageLayout.defaultRowHeight + 2 * PageLayout.gridPadding))
        }
    }
}
