//
//  PageLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 05.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz


class PageLayout {
    let leftMargin = CGFloat(20.0)
    let rightMargin = CGFloat(20.0)
    
    let pdfHeight = CGFloat(1024.0)
    let pdfWidth = CGFloat(768.0)
    
    private let itemsStartYPosition = CGFloat(674)
    private let headerStartingYPosition = CGFloat(900)
    
    private let defaultRowHeight = CGFloat(25.0)
    private let gridPadding = CGFloat(5)
    
    private let fontFormatting = FontFormatting()
    private var itemRowsCounter = 0
    private var breakdownItemsCount = 0
    
    let itemColumnsWidths = [CGFloat(0.05), CGFloat(0.3), CGFloat(0.1), CGFloat(0.05), CGFloat(0.1), CGFloat(0.1), CGFloat(0.1), CGFloat(0.1), CGFloat(0.1)]
    let itemsTableWidth =  CGFloat(728)
    
    func drawInvoiceHeader(header: String) {
        let rect = NSMakeRect(1/2 * self.pdfWidth + CGFloat(100.0),
            headerStartingYPosition,
            1/2 * self.pdfWidth,
            CGFloat(80.0))
        header.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawSeller(seller: String) {
        let rect = NSMakeRect(CGFloat(100.0),
                              headerStartingYPosition - CGFloat(150),
                              1/2 * self.pdfWidth,
                              CGFloat(90.0))
        seller.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawBuyer(buyer: String) {
        let rect = NSMakeRect(1/2 * self.pdfWidth,
                              headerStartingYPosition - CGFloat(150),
                              1/2 * self.pdfWidth,
                              CGFloat(90.0))
        buyer.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawItems(headerData: [String], tableData: [[String]]) {
        itemRowsCounter = tableData.count
        for i in 0 ..< headerData.count {
            drawItemsHeaderCell(content: headerData[i], column: i)
        }
        for i in 0 ..< tableData.count {
            for j in 0 ..< tableData[i].count {
                drawItemTableCell(content: tableData[i][j], row: i, column: j)
            }
        }
        drawItemTableGrid(rows: tableData.count, columns: headerData.count)
    }
    
    private func drawItemTableCell(content: String, row: Int, column: Int) {
        let rect = NSMakeRect(
            leftMargin + self.getColumnXOffset(column: column),
            itemsStartYPosition - (defaultRowHeight * (CGFloat(row) + 1)) - extraItemsHeaderPadding,
            self.getColumnWidth(column: column),
            defaultRowHeight)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    private func drawItemsHeaderCell(content: String, column: Int) {
        let rect = NSMakeRect(
            leftMargin + self.getColumnXOffset(column: column),
            itemsStartYPosition,
            getColumnWidth(column: column),
            defaultRowHeight)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldCenter)
    }
    
    func drawItemsSummary(summaryData: [String]) {
        for i in 0 ..< summaryData.count {
            drawItemsSummaryCell(content: summaryData[i], column: i)
        }
    }
    
    private func drawItemsSummaryCell(content: String, column: Int) {
        let shift = 4
        let rect = NSMakeRect(leftMargin + getColumnXOffset(column: column + shift),
                              itemsSummaryYPosition,
                              getColumnWidth(column: column + shift),
                              defaultRowHeight)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    func drawVatBreakdown(breakdownTableData: [[String]]) {
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
        let rect = NSMakeRect(leftMargin + getColumnXOffset(column: column + shift),
                              itemsSummaryYPosition - CGFloat(row + 1) * defaultRowHeight,
                              getColumnWidth(column: column + shift),
                              defaultRowHeight)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    func drawPaymentSummary(content: String) {
        let rect = NSMakeRect(CGFloat(100.0),
                              paymentSummaryYPosition,
                              1/3 * self.pdfWidth,
                              CGFloat(80.0))
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawPageNumber(content: String) {
        let rect = NSMakeRect(pdfWidth/2,
                             CGFloat(15.0),
                             CGFloat(40.0),
                             CGFloat(20.0))
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesPageNumber)
    }
    
    private func drawItemTableGrid(rows: Int, columns: Int) {
        (0 ... rows + 1).forEach({r in drawItemHorizontalGrid(row: r)})
        (0 ... columns).forEach({c in drawItemVerticalGrid(cell: c)})
    }
    
    private func drawVatBreakdownGrid(rows: Int, columns: Int) {
        (0 ... rows).forEach({r in drawVatBreakdownHorizontalGrid(row: r)})
        (0 ... columns).forEach({c in drawVatBreakdownVerticalGrid(cell: c)})
    }
    
    private func drawItemVerticalGrid(cell: Int) {
        let x = leftMargin + getColumnXOffset(column: cell)
        let fromPoint = NSMakePoint(x, itemsStartYPosition + defaultRowHeight + extraItemsHeaderPadding / 2)
        let toPoint = NSMakePoint(x, itemsStartYPosition - (CGFloat(self.itemRowsCounter) * defaultRowHeight) - extraItemsHeaderPadding / 2)
        drawPath(from: fromPoint, to: toPoint)
    }
    
    private func drawItemHorizontalGrid(row: Int) {
        let y = itemsStartYPosition - (CGFloat(row - 1) * defaultRowHeight) - ( row > 0 ? extraItemsHeaderPadding : 0) + gridPadding
        let fromPoint = NSMakePoint(leftMargin , y)
        let toPoint = NSMakePoint(self.itemsTableWidth + leftMargin, y)
        drawPath(from: fromPoint, to: toPoint)
    }
    
    private func drawVatBreakdownVerticalGrid(cell: Int)  {
        let x = leftMargin + getColumnXOffset(column: cell + 5)
        let fromPoint = NSMakePoint(x, itemsSummaryYPosition + defaultRowHeight + extraItemsHeaderPadding / 2)
        let toPoint = NSMakePoint(x, itemsSummaryYPosition  - (CGFloat(breakdownItemsCount) * defaultRowHeight) + extraItemsHeaderPadding / 2)
        drawPath(from: fromPoint, to: toPoint)
    }
    
    private func drawVatBreakdownHorizontalGrid(row: Int)  {
        let y = itemsSummaryYPosition - (CGFloat(row) * defaultRowHeight) + gridPadding
        let fromPoint = NSMakePoint(leftMargin + self.getColumnXOffset(column: 5) , y)
        let toPoint = NSMakePoint(self.itemsTableWidth + leftMargin, y)
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
    
    private var itemsSummaryYPosition: CGFloat {
        get {
            return itemsStartYPosition - (defaultRowHeight * (CGFloat(self.itemRowsCounter + 1))) - extraItemsHeaderPadding
        }
    }
    
    private var paymentSummaryYPosition: CGFloat {
        get {
            return itemsSummaryYPosition - (CGFloat(self.breakdownItemsCount + 6) * defaultRowHeight)
        }
    }
    
    private var extraItemsHeaderPadding: CGFloat {
        get {
            return 0.4 * defaultRowHeight
        }
    }
    
}
