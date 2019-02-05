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
    }
    
    func drawItemsSummary(summaryData: ItemsSummaryLayout) {
        summaryData.draw()
    }
    
    func drawVatBreakdown(vatBreakdown: VatBreakdownLayout) {
        vatBreakdown.draw()
    }
    
    func drawPaymentSummary(paymentSummary: PaymentSummaryLayout) {
        paymentSummary.draw()
    }
    
    func drawNotes(notes: NotesLayout) {
        notes.draw()
    }
    
}
