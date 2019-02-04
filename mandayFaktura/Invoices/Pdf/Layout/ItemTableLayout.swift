//
//  ItemTableLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class ItemTableLayout : AbstractLayout {
    static let marginTop = CGFloat(50)
    static let yPosition = SellerLayout.yPosition - marginTop
    
    let headerData: [String]
    let tableData: [[String]]
    
    init(headerData: [String], tableData: [[String]]) {
        self.headerData = headerData
        self.tableData = tableData
        super.init(debug: PageLayout.debug)
    }
    
    var height: CGFloat {
        get {
            return heightUpTo(first: self.tableData.count)
        }
    }
    
    func heightUpTo(first: Int) -> CGFloat {
        return (0 ..< first).map({row in calculateRowHeight(index: row)}).reduce(0, +)
    }
    
    func calculateRowHeight(index: Int) -> CGFloat {
        let count = tableData[index][1].count
        let rowLineCount = max(tableData[index][1].linesCount(), Int(ceil(CGFloat(CGFloat(count) / 35.0))))
        let rowHeight = CGFloat(rowLineCount) * PageLayout.defaultRowHeight + PageLayout.gridPadding * 2
        return rowHeight
    }
    
    func draw() {
        (0 ..< self.headerData.count).forEach({col in drawItemsHeaderCell(content: headerData[col], column: col)})
        (0 ..< self.tableData.count).forEach({ row in (0 ..< tableData[row].count).forEach({col in drawItemTableCell(row: row, column: col)})})
    }
    
    private func drawItemsHeaderCell(content: String, column: Int) {
        let xLeft = PageLayout.leftMargin + self.getColumnXOffset(column: column)
        let yBottom = ItemTableLayout.yPosition - PageLayout.gridPadding
        let width = getColumnWidth(column: column)
        let height = PageLayout.defaultRowHeight * 2 + 2 * PageLayout.gridPadding
        fillCellBackground(x: xLeft,y: yBottom, width: width, height: height, color: darkHeaderColor)
        drawItemBorder(xLeft, yBottom, height, width)
        let rect = NSMakeRect(xLeft, yBottom + PageLayout.gridPadding, width, height - 2 * PageLayout.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldCenter)
    }
    
    private func drawItemTableCell(row: Int, column: Int) {
        let rowHeight = calculateRowHeight(index: row)
        let yBottom = ItemTableLayout.yPosition - heightUpTo(first: row + 1) - PageLayout.gridPadding
        let xLeft =  PageLayout.leftMargin + self.getColumnXOffset(column: column)
        let width = self.getColumnWidth(column: column)
        if row % 2 == 1 {
            fillCellBackground(x: xLeft, y: yBottom, width: width, height: rowHeight, color: lightCellColor)
        }
        drawItemBorder(xLeft, yBottom, rowHeight, width)
        let rect = NSMakeRect(xLeft, yBottom + PageLayout.gridPadding, width, rowHeight - 2 * PageLayout.gridPadding)
        tableData[row][column].draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    fileprivate func drawItemBorder(_ xLeft: CGFloat, _ yBottom: CGFloat, _ height: CGFloat, _ width: CGFloat) {
        drawPath(from: NSMakePoint(xLeft, yBottom + height),
                 to: NSMakePoint(xLeft + width, yBottom + height)) // TOP
        drawPath(from: NSMakePoint(xLeft, yBottom),
                 to: NSMakePoint(xLeft + width, yBottom)) // BOTTOM
        drawPath(from: NSMakePoint(xLeft, yBottom + height),
                 to: NSMakePoint(xLeft, yBottom)) // LEFT
        drawPath(from: NSMakePoint(xLeft + width , yBottom + height), // RIGHT
            to: NSMakePoint(xLeft + width, yBottom))
    }
}
