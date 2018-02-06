//
//  PageLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 05.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation


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
    
    var invoiceHeaderLayout: (NSRect, [NSAttributedStringKey: Any]) {
        let rect = NSMakeRect(1/2 * self.pdfWidth + CGFloat(100.0),
                              headerStartingYPosition,
                              1/2 * self.pdfWidth,
                              CGFloat(80.0))
        return (rect, self.fontFormatting.fontAttributesBoldLeft)
    }
    
    var sellerLayout: (NSRect, [NSAttributedStringKey: Any]) {
        let rect = NSMakeRect(CGFloat(100.0),
                              headerStartingYPosition - CGFloat(150),
                              1/2 * self.pdfWidth,
                              CGFloat(90.0))
        return (rect, self.fontFormatting.fontAttributesBoldLeft)
    }
    
    var buyerLayout: (NSRect, [NSAttributedStringKey: Any]) {
        let rect = NSMakeRect(1/2 * self.pdfWidth,
                              headerStartingYPosition - CGFloat(150),
                              1/2 * self.pdfWidth,
                              CGFloat(90.0))
        return (rect, self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func itemCellLayout(row: Int, column: Int) -> (NSRect, [NSAttributedStringKey: Any]) {
        itemRowsCounter = max(itemRowsCounter, row + 1)
        let rect = NSMakeRect(
            leftMargin + self.getColumnXOffset(column: column),
            itemsStartYPosition - (defaultRowHeight * (CGFloat(row) + 1)),
            self.getColumnWidth(column: column),
            defaultRowHeight)
        return (rect, self.fontFormatting.fontAttributesCenter)
    }
    
    func itemsHeaderCell(column: Int) -> (NSRect, [NSAttributedStringKey: Any]) {
        let rect = NSMakeRect(
            leftMargin + self.getColumnXOffset(column: column),
            itemsStartYPosition,
            getColumnWidth(column: column),
            defaultRowHeight)
        return (rect, self.fontFormatting.fontAttributesBoldCenter)
    }
    
    func itemsSummaryCell(column: Int) -> (NSRect, [NSAttributedStringKey: Any]) {
        let shift = 4
        let rect = NSMakeRect(leftMargin + getColumnXOffset(column: column + shift),
                              itemsStartYPosition - (defaultRowHeight * (CGFloat(self.itemRowsCounter + 1))),
                              getColumnWidth(column: column + shift),
                              defaultRowHeight)
        return (rect, self.fontFormatting.fontAttributesCenter)
    }
    
    func vatBreakdownCell(row: Int, column: Int) -> (NSRect, [NSAttributedStringKey: Any]) {
        let shift = 5
        let rect = NSMakeRect(leftMargin + getColumnXOffset(column: column + shift),
                              itemsStartYPosition - (defaultRowHeight * (CGFloat(self.itemRowsCounter + 2 + row))),
                              getColumnWidth(column: column + shift),
                              defaultRowHeight)
        return (rect, self.fontFormatting.fontAttributesCenter)
    }
    
    var paymentSummaryLayout: (NSRect, [NSAttributedStringKey: Any]) {
        get {
            let rect = NSMakeRect(CGFloat(100.0),
                                  itemsStartYPosition - (13 + CGFloat(self.itemRowsCounter)) * defaultRowHeight,
                                  1/3 * self.pdfWidth,
                                  1/5 * self.pdfHeight)
            return (rect, self.fontFormatting.fontAttributesBoldLeft)
        }
    }
    
    var pageNumberLayout: (NSRect, [NSAttributedStringKey: Any]) {
        get {
            let rect = NSMakeRect(pdfWidth/2,
                                         CGFloat(15.0),
                                         CGFloat(40.0),
                                         CGFloat(20.0))
             return (rect, self.fontFormatting.fontAttributesPageNumber)
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
