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

    init(invoice:Invoice, pageNumber:Int) {
        self.invoice = invoice
        super.init(pageNumber: pageNumber)
    }
    
    func drawInvoiceHeader()  {
        let (rect, fontAttributes) = pageLayout.invoiceHeaderLayout
        invoice.printedHeader.draw(in: rect, withAttributes: fontAttributes)
    }
    
    func drawSeller() {
        let (rect, fontAttributes) = pageLayout.sellerLayout
        invoice.seller.printedSeller.draw(in: rect, withAttributes: fontAttributes)
    }
    
    func drawBuyer() {
        let (rect, fontAttributes) = pageLayout.buyerLayout
        invoice.buyer.printedBuyer.draw(in: rect, withAttributes: fontAttributes)
    }
    
    func drawItems() {
        drawItemsHeader()
        for itemCounter in 0 ..< self.invoice.items.count {
            let properties = [(itemCounter + 1).description] + self.invoice.items[itemCounter].propertiesForDisplay
            for propertyCounter in 0 ..< properties.count {
                let (rect, fontAttributes) = pageLayout.itemCellLayout(row: itemCounter,column: propertyCounter)
                properties[propertyCounter].draw(in: rect, withAttributes: fontAttributes)
            }
        }
        self.drawVerticalGrids()
        self.drawHorizontalGrids()
    }
    
    func drawItemsHeader() {
        for column in 0 ..< InvoiceItem.itemColumnNames.count {
            let (rect, fontAttributes) = pageLayout.itemsHeaderCell(column: column)
            InvoiceItem.itemColumnNames[column].draw(in: rect, withAttributes: fontAttributes)
        }
    }
    
    func drawItemsSummary() {
        var propertyCounter = 0
        (["Razem:"] + self.invoice.propertiesForDisplay).forEach { prop in
            let (rect, fontAttributes) = pageLayout.itemsSummaryCell(column: propertyCounter)
            propertyCounter = propertyCounter + 1
            prop.draw(in: rect, withAttributes: fontAttributes)
        }
        drawVatBreakdown()
    }
    
    func drawVatBreakdown() {
        for breakdownIndex in 0 ..< self.invoice.vatBreakdown.entries.count {
            let breakdown = self.invoice.vatBreakdown.entries[breakdownIndex]
            for propIndex in 0 ..< breakdown.propertiesForDisplay.count {
                let (rect, fontAttributes) = pageLayout.vatBreakdownCell(row: breakdownIndex, column: propIndex)
                breakdown.propertiesForDisplay[propIndex].draw(in: rect, withAttributes: fontAttributes)
            }
        }
    }
    
    func drawPaymentSummary() {
        let (rect, fontAttributes) = pageLayout.paymentSummaryLayout
        invoice.printedPaymentSummary.draw(in: rect, withAttributes: fontAttributes)
    }
    
   
    func drawVerticalGrids(){
        for i in 0 ..< InvoiceItem.itemColumnNames.count + 1 {
            let (fromPoint, toPoint) = pageLayout.itemVerticalGrid(cell: i)
            drawLine(fromPoint: fromPoint, toPoint: toPoint)
        }
    }
    
    func drawHorizontalGrids(){
        let rowCount = self.invoice.items.count + 2
        for i in 0 ..< rowCount {
            let (fromPoint, toPoint) = pageLayout.itemHorizontalGrid(row: i)
            drawLine(fromPoint: fromPoint, toPoint: toPoint)
        }
    }
    
    override func draw(with box: PDFDisplayBox) {
        super.draw(with: box)
        self.drawInvoiceHeader()
        self.drawSeller()
        self.drawBuyer()
        self.drawItems()
        self.drawItemsSummary()
        self.drawPaymentSummary()
    }
}
