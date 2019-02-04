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
    
    func height() -> CGFloat {
        var startFromY = CGFloat(0)
        for i in 0 ..< self.tableData.count {
            startFromY = startFromY + calculateRowHeight(index: i)
        }
        return startFromY
    }
    
    func calculateRowHeight(index: Int) -> CGFloat {
        let count = tableData[index][1].count
        let rowLineCount = max(tableData[index][1].linesCount(), Int(ceil(CGFloat(CGFloat(count) / 35.0))))
        let rowHeight = CGFloat(rowLineCount) * PageLayout.defaultRowHeight + PageLayout.gridPadding * 2
        return rowHeight
    }
    
    func draw() {
        for i in 0 ..< self.headerData.count {
            drawItemsHeaderCell(content: headerData[i], column: i)
        }
        var startFromY = ItemTableLayout.yPosition
        for i in 0 ..< self.tableData.count {
            let rowHeight = calculateRowHeight(index: i)
            startFromY = startFromY - rowHeight
            for j in 0 ..< tableData[i].count {
                drawItemTableCell(content: tableData[i][j], row: i, column: j, rowHeight: rowHeight, startFromY: startFromY)
            }
        }
    }
    
    private func drawItemsHeaderCell(content: String, column: Int) {
        let xLeft = PageLayout.leftMargin + self.getColumnXOffset(column: column)
        let yBottom = ItemTableLayout.yPosition
        let width = getColumnWidth(column: column)
        let height = PageLayout.defaultRowHeight * 2
        let rect = NSMakeRect(xLeft, ItemTableLayout.yPosition, width, height)
        fillCellBackground(x: PageLayout.leftMargin + self.getColumnXOffset(column: column),
                           y: yBottom - PageLayout.gridPadding,
                           width:  getColumnWidth(column: column),
                           height: height + 2 * PageLayout.gridPadding,
                           color: darkHeaderColor)
        drawItemBorder(xLeft, yBottom, height, width)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldCenter)
    }
    
    private func drawItemTableCell(content: String, row: Int, column: Int, rowHeight: CGFloat, startFromY: CGFloat) {
        let yBottom = startFromY
        let xLeft =  PageLayout.leftMargin + self.getColumnXOffset(column: column)
        let width = self.getColumnWidth(column: column)
        let rect = NSMakeRect(xLeft, yBottom, width, rowHeight - 2 * PageLayout.gridPadding)
        if row % 2 == 1{
            fillCellBackground(x: xLeft,
                               y: yBottom - PageLayout.gridPadding,
                               width:  width,
                               height: rowHeight,
                               color: lightCellColor)
        }
        drawItemBorder(xLeft, yBottom - PageLayout.gridPadding, rowHeight, width)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
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
