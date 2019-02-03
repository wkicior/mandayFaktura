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
   
    private let defaultRowHeight = CGFloat(14)
    private let gridPadding = CGFloat(5)
    
    private let fontFormatting = FontFormatting()
    private var itemRowsCounter = 0
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
    
    func drawItemsTable(headerData: [String], tableData: [[String]]) {
        itemRowsCounter = 0 // TODO PageLayout is being reused for copy as well - fix this
        for i in 0 ..< headerData.count {
            drawItemsHeaderCell(content: headerData[i], column: i)
        }
        var startFromY = itemsStartYPosition
        for i in 0 ..< tableData.count {
            let count = tableData[i][1].count
            let rowLineCount = max(tableData[i][1].linesCount(), Int(ceil(CGFloat(CGFloat(count) / 35.0))))
            itemRowsCounter = itemRowsCounter + rowLineCount
            startFromY = startFromY - CGFloat(rowLineCount) * defaultRowHeight - gridPadding * 2
            for j in 0 ..< tableData[i].count {
                drawItemTableCell(content: tableData[i][j], row: i, column: j, size: CGFloat(rowLineCount), startFromY: startFromY)
            }
        }
        self.itemsSummaryYPosition = startFromY
    }
    
    private func drawItemsHeaderCell(content: String, column: Int) {
        let xLeft = PageLayout.leftMargin + self.getColumnXOffset(column: column)
        let yBottom = itemsStartYPosition
        let width = getColumnWidth(column: column)
        let height = defaultRowHeight * 2
        let rect = NSMakeRect(xLeft, itemsStartYPosition, width, height)
        fillCellBackground(x: PageLayout.leftMargin + self.getColumnXOffset(column: column),
                           y: yBottom - gridPadding,
                           width:  getColumnWidth(column: column),
                           height: height + 2 * gridPadding,
                           color: darkHeaderColor)
        drawItemBorder(xLeft, yBottom, height, width)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldCenter)
    }
    
    private func drawItemTableCell(content: String, row: Int, column: Int, size: CGFloat, startFromY: CGFloat) {
        let yBottom = startFromY
        let xLeft =  PageLayout.leftMargin + self.getColumnXOffset(column: column)
        let width = self.getColumnWidth(column: column)
        let height = defaultRowHeight * size
        let rect = NSMakeRect(xLeft, yBottom, width, height)
        if row % 2 == 1{
            fillCellBackground(x: xLeft,
                               y: yBottom - gridPadding,
                               width:  width,
                               height: height + 2 * gridPadding,
                               color: lightCellColor)
        }
        drawItemBorder(xLeft, yBottom, height, width)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    fileprivate func drawItemBorder(_ xLeft: CGFloat, _ yBottom: CGFloat, _ height: CGFloat, _ width: CGFloat) {
        drawPath(from: NSMakePoint(xLeft, yBottom + gridPadding + height),
                 to: NSMakePoint(xLeft + width, yBottom + gridPadding + height)) // TOP
        drawPath(from: NSMakePoint(xLeft, yBottom - gridPadding),
                 to: NSMakePoint(xLeft + width, yBottom - gridPadding)) // BOTTOM
        drawPath(from: NSMakePoint(xLeft, yBottom + gridPadding + height),
                 to: NSMakePoint(xLeft, yBottom - gridPadding)) // LEFT
        drawPath(from: NSMakePoint(xLeft + width , yBottom + gridPadding + height), // RIGHT
            to: NSMakePoint(xLeft + width, yBottom - gridPadding))
    }
    
    func fillCellBackground(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: NSColor) {
        let rectBackground = NSMakeRect(x, y, width, height)
        color.set()
        __NSRectFill(rectBackground)
    }
    
    func drawItemsSummary(summaryData: [String]) {
        self.itemsSummaryYPosition = self.itemsSummaryYPosition - defaultRowHeight - 2 * gridPadding
        for i in 0 ..< summaryData.count {
            drawItemsSummaryCell(content: summaryData[i], column: i)
        }
    }
    
    private func drawItemsSummaryCell(content: String, column: Int) {
        let shift = 4

        let rect = NSMakeRect(PageLayout.leftMargin + getColumnXOffset(column: column + shift),
                              itemsSummaryYPosition,
                              getColumnWidth(column: column + shift),
                              defaultRowHeight)
        fillCellBackground(x: PageLayout.leftMargin + getColumnXOffset(column: column + shift),
                           y: itemsSummaryYPosition - gridPadding,
                           width:  self.getColumnWidth(column: column + shift),
                           height: defaultRowHeight + 2 * gridPadding,
                           color: darkHeaderColor)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    func drawVatBreakdown(breakdownLabel: String, breakdownTableData: [[String]]) {
        self.itemsSummaryYPosition = self.itemsSummaryYPosition - defaultRowHeight - 2 * gridPadding
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
        let yBottom = itemsSummaryYPosition - CGFloat(row) * (defaultRowHeight + 2 * gridPadding)
        let xLeft = PageLayout.leftMargin + getColumnXOffset(column: column + shift)
        let width = getColumnWidth(column: column + shift)
        let height = defaultRowHeight
        let rect = NSMakeRect(xLeft, yBottom, width, height)
        if row % 2 == 1{
            fillCellBackground(x: xLeft,
                               y: yBottom - gridPadding,
                               width:  width,
                               height: height + 2 * gridPadding,
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
        let fromPoint = NSMakePoint(x, itemsSummaryYPosition + 2 * (defaultRowHeight + 2 * gridPadding))
        let toPoint = NSMakePoint(x, itemsSummaryYPosition - gridPadding - (CGFloat(breakdownItemsCount - 1) * (defaultRowHeight + 2 * gridPadding)))
        drawPath(from: fromPoint, to: toPoint)
    }
    
    private func drawVatBreakdownHorizontalGrid(row: Int, of: Int)  {
        let y = itemsSummaryYPosition - CGFloat(row - 1) * (defaultRowHeight + 2 * gridPadding) - gridPadding
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
            return itemsSummaryYPosition - (CGFloat(self.breakdownItemsCount + 6) * (defaultRowHeight + 2 * gridPadding))
        }
    }
}
