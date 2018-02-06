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
    
    private let itemsStartYPosition = CGFloat(574)
    private let headerStartingYPosition = CGFloat(900)
    
    private let defaultRowHeight  = CGFloat(25.0)
    private let defaultColumnWidth = CGFloat(80.0)
    
    private let fontFormatting = FontFormatting()
    private var itemRows = 0
    
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
                              CGFloat(80.0))
        return (rect, self.fontFormatting.fontAttributesBoldLeft)
    }
    
    var buyerLayout: (NSRect, [NSAttributedStringKey: Any]) {
        let rect = NSMakeRect(1/2 * self.pdfWidth,
                              headerStartingYPosition - CGFloat(150),
                              1/2 * self.pdfWidth,
                              CGFloat(80.0))
        return (rect, self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func itemCellLayout(row: Int, column: Int) -> (NSRect, [NSAttributedStringKey: Any]) {
        itemRows = max(itemRows, row + 1)
        let rect = NSMakeRect(
            leftMargin + (CGFloat(column) * defaultColumnWidth),
            itemsStartYPosition - (defaultRowHeight * (CGFloat(row) + 1)),
            defaultColumnWidth,
            defaultRowHeight)
        return (rect, self.fontFormatting.fontAttributesCenter)
    }
    
    func itemsHeaderCell(column: Int) -> (NSRect, [NSAttributedStringKey: Any]) {
        let rect = NSMakeRect(
            leftMargin + (CGFloat(column) * defaultColumnWidth),
            itemsStartYPosition,
            defaultColumnWidth,
            defaultRowHeight)
        return (rect, self.fontFormatting.fontAttributesBoldCenter)
    }
    
    func itemsSummaryCell(column: Int) -> (NSRect, [NSAttributedStringKey: Any]) {
        let rect = NSMakeRect(leftMargin + (CGFloat(InvoiceItem.itemColumnNames.count - 5 + column) * defaultColumnWidth),
                              itemsStartYPosition - (defaultRowHeight * (CGFloat(self.itemRows + 1))),
                              defaultColumnWidth,
                              defaultRowHeight)
        return (rect, self.fontFormatting.fontAttributesCenter)
    }
    
    func vatBreakdownCell(row: Int, column: Int) -> (NSRect, [NSAttributedStringKey: Any]) {
        let x = leftMargin + (CGFloat(InvoiceItem.itemColumnNames.count - 4 + column) * defaultColumnWidth)
        let y =  itemsStartYPosition - (defaultRowHeight * (CGFloat(self.itemRows + 2 + row)))
        let rect = NSMakeRect(x, y, defaultColumnWidth, defaultRowHeight)
        return (rect, self.fontFormatting.fontAttributesCenter)
    }
    
    var paymentSummaryLayout: (NSRect, [NSAttributedStringKey: Any]) {
        get {
            let rect = NSMakeRect(CGFloat(100.0),
                                  itemsStartYPosition - (13 + CGFloat(self.itemRows)) * defaultRowHeight,
                                  1/3 * self.pdfWidth,
                                  1/5 * self.pdfHeight)
            return (rect, self.fontFormatting.fontAttributesBoldLeft)
        }
    }
    
    func itemVerticalGrid(cell: Int) -> (NSPoint, NSPoint) {
        let x = leftMargin + (CGFloat(cell) * defaultColumnWidth)
        let fromPoint = NSMakePoint(x, itemsStartYPosition + defaultRowHeight)
        let toPoint = NSMakePoint(x, itemsStartYPosition - (CGFloat(self.itemRows) * defaultRowHeight))
        return (fromPoint, toPoint)
    }
    
    func itemHorizontalGrid(row: Int) -> (NSPoint, NSPoint) {
        let y = itemsStartYPosition - (CGFloat(row - 1) * defaultRowHeight)
        let fromPoint = NSMakePoint(leftMargin , y)
        let toPoint = NSMakePoint(self.pdfWidth - rightMargin, y)
        return (fromPoint, toPoint)
    }
    
}
