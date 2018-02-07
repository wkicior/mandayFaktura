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
    let topMargin = CGFloat(40.0)
    let leftMargin = CGFloat(20.0)
    let rightMargin = CGFloat(20.0)
    let bottomMargin = CGFloat (40.0)
    let textInset = CGFloat(5.0)
    let verticalPadding = CGFloat (10.0)
    
    let pdfHeight = CGFloat(1024.0)
    let pdfWidth = CGFloat(768.0)
    
    private let itemsStartYPosition = CGFloat(674)
    private let headerStartingYPosition = CGFloat(900)
    
    private let defaultRowHeight  = CGFloat(25.0)
    
    private let fontFormatting = FontFormatting()
    private var itemRowsCounter = 0
    
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
        for i in 0 ..< headerData.count {
            drawItemsHeaderCell(content: headerData[i], column: i)
        }
        for i in 0 ..< tableData.count {
            for j in 0 ..< tableData[i].count {
                drawItemTableCell(content: tableData[i][j], row: i, column: j)
            }
        }
        itemTableGrid(rows: tableData.count, columns: headerData.count)

    }
    private func drawItemTableCell(content: String, row: Int, column: Int) {
        itemRowsCounter = max(itemRowsCounter, row + 1)
        let rect = NSMakeRect(
            leftMargin + self.getColumnXOffset(column: column),
            itemsStartYPosition - (defaultRowHeight * (CGFloat(row) + 1)),
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
                              itemsStartYPosition - (defaultRowHeight * (CGFloat(self.itemRowsCounter + 1))),
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
    }
    private func drawVatBreakdownCell(content: String, row: Int, column: Int) {
        let shift = 5
        let rect = NSMakeRect(leftMargin + getColumnXOffset(column: column + shift),
                              itemsStartYPosition - (defaultRowHeight * (CGFloat(self.itemRowsCounter + 2 + row))),
                              getColumnWidth(column: column + shift),
                              defaultRowHeight)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    func drawPaymentSummary(content: String) {
        let rect = NSMakeRect(CGFloat(100.0),
                              itemsStartYPosition - (13 + CGFloat(self.itemRowsCounter)) * defaultRowHeight,
                              1/3 * self.pdfWidth,
                              1/5 * self.pdfHeight)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawPageNumber(content: String) {
        let rect = NSMakeRect(pdfWidth/2,
                             CGFloat(15.0),
                             CGFloat(40.0),
                             CGFloat(20.0))
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesPageNumber)
    }
    
    private func itemTableGrid(rows: Int, columns: Int) {
        for r in 0 ..< rows + 2 {
            let path = NSBezierPath()
            NSColor.lightGray.set()
            let (fromPoint, toPoint) = itemHorizontalGrid(row: r)
            path.move(to: fromPoint)
            path.line(to: toPoint)
            path.lineWidth = 0.5
            path.stroke()
        }
        for c in 0 ..< columns + 1 {
            let path = NSBezierPath()
            NSColor.lightGray.set()
            let (fromPoint, toPoint) = itemVerticalGrid(cell: c)
            path.move(to: fromPoint)
            path.line(to: toPoint)
            path.lineWidth = 0.5
            path.stroke()
        }
    }
    
    func itemVerticalGrid(cell: Int) -> (NSPoint, NSPoint) {
        let x = leftMargin + getColumnXOffset(column: cell)
        let fromPoint = NSMakePoint(x, itemsStartYPosition + defaultRowHeight)
        let toPoint = NSMakePoint(x, itemsStartYPosition - (CGFloat(self.itemRowsCounter) * defaultRowHeight))
        return (fromPoint, toPoint)
    }
    
    func itemHorizontalGrid(row: Int) -> (NSPoint, NSPoint) {
        let y = itemsStartYPosition - (CGFloat(row - 1) * defaultRowHeight)
        let fromPoint = NSMakePoint(leftMargin , y)
        let toPoint = NSMakePoint(self.itemsTableWidth + leftMargin, y)
        return (fromPoint, toPoint)
    }
    
    private func getColumnWidth(column: Int) -> CGFloat {
        return itemColumnsWidths[column] * itemsTableWidth
    }
    
    func getColumnXOffset(column: Int) -> CGFloat {
        let safeColumnNo = min(column, itemColumnsWidths.count)
        return self.itemColumnsWidths.prefix(upTo: safeColumnNo).reduce(0, +) * itemsTableWidth
    }
    
}
