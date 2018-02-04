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
    let dateFormatter = DateFormatter()
    let fontFormatting = FontFormatting()
   
    let defaultRowHeight  = CGFloat(25.0)
    let defaultColumnWidth = CGFloat(80.0)
    
    let itemsStartYPosition: CGFloat

    init(invoice:Invoice, pageNumber:Int) {
        self.invoice = invoice
        self.dateFormatter.timeStyle = .none
        self.dateFormatter.dateStyle = .short
        self.itemsStartYPosition = CGFloat(574)

        super.init(pageNumber: pageNumber)
    }
    
    func drawInvoiceHeader() {
        let rect = NSMakeRect(1/2 * self.pdfWidth + CGFloat(100.0), self.pdfHeight - CGFloat(300.0),
                                       1/2 * self.pdfWidth, 1/5 * self.pdfHeight)
        let msg =
        """
        Faktura VAT
        Nr: \(self.invoice.number)
        Data wystawienia: \(self.getDateString(self.invoice.issueDate))
        Data sprzedaży: \(self.getDateString(self.invoice.sellingDate))
        
        
        ORYGINAŁ
        """
        msg.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawSeller() {
        let rect = NSMakeRect(CGFloat(100.0), self.pdfHeight - CGFloat(450.0),
                              1/2 * self.pdfWidth, 1/5 * self.pdfHeight)
        let msg =
        """
        Sprzedawca:
        \(self.invoice.seller.name)
        \(self.invoice.seller.streetAndNumber)
        \(self.invoice.seller.postalCode) \(self.invoice.seller.city)
        NIP: \(self.invoice.seller.taxCode)
        Nr konta: \(self.invoice.seller.accountNumber)
        """
        msg.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawBuyer() {
        let rect = NSMakeRect(1/2 * self.pdfWidth, self.pdfHeight - CGFloat(450.0),
                              1/2 * self.pdfWidth, 1/5 * self.pdfHeight)
        let msg =
        """
        Nabywca:
        \(self.invoice.buyer.name)
        \(self.invoice.buyer.streetAndNumber)
        \(self.invoice.buyer.postalCode) \(self.invoice.buyer.city)
        NIP: \(self.invoice.buyer.taxCode)
        """
        msg.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawItems() {
        drawItemsHeader()
        var itemCounter = 0

        self.invoice.items.forEach { item in
           var propertyCounter = 0
            let properties = [(itemCounter + 1).description] + item.propertiesForDisplay
            properties.forEach { property in
                let rect = NSMakeRect(
                    leftMargin + (CGFloat(propertyCounter) * defaultColumnWidth),
                    itemsStartYPosition - (defaultRowHeight * (CGFloat(itemCounter) + 1)),
                    defaultColumnWidth,
                    defaultRowHeight)
                propertyCounter = propertyCounter + 1
                property.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
            }
            itemCounter = itemCounter + 1
        }
        self.drawVerticalGrids()
        self.drawHorizontalGrids()
    }
    
    func drawItemsHeader() {
        var counter = 0
        InvoiceItem.itemColumnNames.forEach { name in
            let rect = NSMakeRect(
                leftMargin + (CGFloat(counter) * defaultColumnWidth),
                itemsStartYPosition,
                defaultColumnWidth,
                defaultRowHeight)
            counter = counter + 1
            name.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldCenter)
        }
    }
    
    func drawItemsSummary() {
        drawItemsSummaryHeader()
        var propertyCounter = 0
        (["Razem:"] + self.invoice.propertiesForDisplay).forEach { prop in
            let rect = NSMakeRect(self.pdfWidth / 2 + leftMargin + (CGFloat(propertyCounter) * defaultColumnWidth),
                                  itemsStartYPosition - (3 + CGFloat(self.invoice.items.count)) * defaultRowHeight,
                                  defaultColumnWidth,
                                  defaultRowHeight)
            propertyCounter = propertyCounter + 1
            prop.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
        }
        drawVatBreakdown()
    }
    
    func drawItemsSummaryHeader() {
        var counter = 0
        ([""] + Invoice.summaryColumnNames).forEach { name in
            let rect = NSMakeRect(self.pdfWidth / 2 + leftMargin + (CGFloat(counter) * defaultColumnWidth),
                                  itemsStartYPosition - (2 + CGFloat(self.invoice.items.count)) * defaultRowHeight,
                                  defaultColumnWidth,
                                  defaultRowHeight)
            counter = counter + 1
            name.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldCenter)
            
        }
    }
    
    func drawVatBreakdown() {
        let yStart = itemsStartYPosition - (4 + CGFloat(self.invoice.items.count)) * defaultRowHeight
        for breakdownIndex in 0 ..< self.invoice.vatBreakdown.entries.count {
            let breakdown = self.invoice.vatBreakdown.entries[breakdownIndex]
            for propIndex in 0 ..< breakdown.propertiesForDisplay.count {
                let x = self.pdfWidth / 2 + leftMargin + (CGFloat(propIndex) * defaultColumnWidth)
                let y = yStart - (CGFloat(breakdownIndex) * defaultRowHeight)
                let rect = NSMakeRect(x, y, defaultColumnWidth, defaultRowHeight)
                breakdown.propertiesForDisplay[propIndex].draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
            }
        }
    }
    
    func drawPaymentSummary() {
        let rect = NSMakeRect(CGFloat(100.0), itemsStartYPosition - (13 + CGFloat(self.invoice.items.count)) * defaultRowHeight,
                                1/3 * self.pdfWidth, 1/5 * self.pdfHeight)
        
        let msg =
        """
        Do zapłaty \(self.invoice.totalGrossValue) PLN
        słownie: \(self.invoice.totalGrossValue.spelledOut) PLN
        forma płatności: \(self.invoice.paymentFormLabel)
        termin płatności: \(self.getDateString(self.invoice.paymentDueDate))
        """
        msg.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func getDateString(_ date: Date) -> String {
        return self.dateFormatter.string(from: date)
    }
    
    func drawVerticalGrids(){
        for i in 0 ..< InvoiceItem.itemColumnNames.count + 1 {
            let x = leftMargin + (CGFloat(i) * defaultColumnWidth)
            let fromPoint = NSMakePoint(x, itemsStartYPosition + defaultRowHeight)
            let toPoint = NSMakePoint(x, itemsStartYPosition - (CGFloat(self.invoice.items.count) * defaultRowHeight))
            drawLine(fromPoint: fromPoint, toPoint: toPoint)
        }
    }
    
    func drawHorizontalGrids(){
        let rowCount = self.invoice.items.count + 2
        for i in 0 ..< rowCount {
            let y = itemsStartYPosition - (CGFloat(i - 1) * defaultRowHeight)
            let fromPoint = NSMakePoint(leftMargin , y)
            let toPoint = NSMakePoint(self.pdfWidth - rightMargin, y)
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
