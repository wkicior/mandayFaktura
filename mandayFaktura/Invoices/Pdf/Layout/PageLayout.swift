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
    
    private let itemsStartYPosition = CGFloat(674)
   
    static let defaultRowHeight = CGFloat(14)
    static let gridPadding = CGFloat(5)
    
    private let fontFormatting = FontFormatting()
    private var breakdownItemsCount = 0
    
    private let lightCellColor = NSColor.fromRGB(red: 215, green: 233, blue: 246)
    private let darkHeaderColor =  NSColor.fromRGB(red: 90, green: 164, blue: 218)
    
    let itemColumnsWidths = [CGFloat(0.05), CGFloat(0.3), CGFloat(0.1), CGFloat(0.05), CGFloat(0.1), CGFloat(0.1), CGFloat(0.1), CGFloat(0.1), CGFloat(0.1)]
    let itemsTableWidth =  CGFloat(728)
    
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
    
    func fillCellBackground(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: NSColor) {
        let rectBackground = NSMakeRect(x, y, width, height)
        color.set()
        __NSRectFill(rectBackground)
    }
    
    func drawItemsSummary(summaryData: ItemsSummaryLayout) {
        summaryData.draw(yPosition: self.itemsSummaryYPosition) //TODO: clean this up
        self.itemsSummaryYPosition = summaryData.yPosition
    }
    
    
    
    func drawVatBreakdown(breakdownLabel: String, breakdownTableData: [[String]]) {
        self.itemsSummaryYPosition = self.itemsSummaryYPosition - PageLayout.defaultRowHeight - 2 * PageLayout.gridPadding
        drawVatBreakdownCell(content: breakdownLabel, row: 0, column: -1)
        for i in 0 ..< breakdownTableData.count {
            for j in 0 ..< breakdownTableData[i].count {
                drawVatBreakdownCell(content: breakdownTableData[i][j], row: i,column: j)
            }
        }
        breakdownItemsCount = breakdownTableData.count
        drawVatBreakdownGrid(rows: breakdownTableData.count, columns: breakdownTableData[0].count)
    }
    
    private func drawVatBreakdownCell(content: String, row: Int, column: Int) {
        let shift = 5
        let yBottom = itemsSummaryYPosition - CGFloat(row) * (PageLayout.defaultRowHeight + 2 * PageLayout.gridPadding)
        let xLeft = PageLayout.leftMargin + getColumnXOffset(column: column + shift)
        let width = getColumnWidth(column: column + shift)
        let height = PageLayout.defaultRowHeight
        let rect = NSMakeRect(xLeft, yBottom, width, height)
        if row % 2 == 1{
            fillCellBackground(x: xLeft,
                               y: yBottom - PageLayout.gridPadding,
                               width:  width,
                               height: height + 2 * PageLayout.gridPadding,
                               color: lightCellColor)
        }
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    func drawPaymentSummary(content: String) {
        drawPaymentSummaryHorizontalLine()
        let rect = NSMakeRect(CGFloat(100.0),
                              paymentSummaryYPosition,
                              1/3 * PageLayout.pdfWidth,
                              CGFloat(80.0))
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawNotes(content: String) {
        let rect = NSMakeRect(PageLayout.leftMargin, paymentSummaryYPosition - CGFloat(100.0), PageLayout.pdfWidth - PageLayout.rightMargin, CGFloat(100.0))
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesLeft)
    }
    
    func drawPaymentSummaryHorizontalLine() {
        let y =  paymentSummaryYPosition + CGFloat(90)
        let fromPoint = NSMakePoint(PageLayout.leftMargin , y)
        let toPoint = NSMakePoint(PageLayout.pdfWidth - PageLayout.rightMargin, y)
        drawPath(from: fromPoint, to: toPoint)
    }
    
    private func drawVatBreakdownGrid(rows: Int, columns: Int) {
        (0 ... rows).forEach({r in drawVatBreakdownHorizontalGrid(row: r, of: rows)})
        (0 ... columns + 1).forEach({c in drawVatBreakdownVerticalGrid(cell: c)})
    }
    
    private func drawVatBreakdownVerticalGrid(cell: Int)  {
        let x = PageLayout.leftMargin + getColumnXOffset(column: cell + 4)
        let fromPoint = NSMakePoint(x, itemsSummaryYPosition + 2 * (PageLayout.defaultRowHeight + 2 * PageLayout.gridPadding))
        let toPoint = NSMakePoint(x, itemsSummaryYPosition - PageLayout.gridPadding - (CGFloat(breakdownItemsCount - 1) * (PageLayout.defaultRowHeight + 2 * PageLayout.gridPadding)))
        drawPath(from: fromPoint, to: toPoint)
    }
    
    private func drawVatBreakdownHorizontalGrid(row: Int, of: Int)  {
        let y = itemsSummaryYPosition - CGFloat(row - 1) * (PageLayout.defaultRowHeight + 2 * PageLayout.gridPadding) - PageLayout.gridPadding
        let isFirstOrLastRow = row == of || row == 0
        let fromPoint = NSMakePoint(PageLayout.leftMargin + self.getColumnXOffset(column: isFirstOrLastRow ? 4 : 5) , y)
        let toPoint = NSMakePoint(self.itemsTableWidth + PageLayout.leftMargin, y)
        drawPath(from: fromPoint, to: toPoint)
    }
    
    private func drawPath(from: NSPoint, to: NSPoint) {
        let path = NSBezierPath()
        NSColor.lightGray.set()
        path.move(to: from)
        path.line(to: to)
        path.lineWidth = 0.5
        path.stroke()
    }
    
    private func getColumnWidth(column: Int) -> CGFloat {
        return itemColumnsWidths[column] * itemsTableWidth
    }
    
    func getColumnXOffset(column: Int) -> CGFloat {
        let safeColumnNo = min(column, itemColumnsWidths.count)
        return self.itemColumnsWidths.prefix(upTo: safeColumnNo).reduce(0, +) * itemsTableWidth
    }
    
    private var paymentSummaryYPosition: CGFloat {
        get {
            return itemsSummaryYPosition - (CGFloat(self.breakdownItemsCount + 6) * (PageLayout.defaultRowHeight + 2 * PageLayout.gridPadding))
        }
    }
}
