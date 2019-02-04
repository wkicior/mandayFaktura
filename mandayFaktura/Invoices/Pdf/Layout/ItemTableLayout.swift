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

    var itemsSummaryYPosition = CGFloat(0)
    
    let headerData: [String]
    let tableData: [[String]]
    
    init(headerData: [String], tableData: [[String]]) {
        self.headerData = headerData
        self.tableData = tableData
        super.init(debug: PageLayout.debug)
    }
    
    func draw() {
        for i in 0 ..< self.headerData.count {
            drawItemsHeaderCell(content: headerData[i], column: i)
        }
        var startFromY = ItemTableLayout.yPosition
        for i in 0 ..< self.tableData.count {
            let count = tableData[i][1].count
            let rowLineCount = max(tableData[i][1].linesCount(), Int(ceil(CGFloat(CGFloat(count) / 35.0))))
            startFromY = startFromY - CGFloat(rowLineCount) * PageLayout.defaultRowHeight - PageLayout.gridPadding * 2
            for j in 0 ..< tableData[i].count {
                drawItemTableCell(content: tableData[i][j], row: i, column: j, size: CGFloat(rowLineCount), startFromY: startFromY)
            }
        }
        self.itemsSummaryYPosition = startFromY
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
    
    private func drawItemTableCell(content: String, row: Int, column: Int, size: CGFloat, startFromY: CGFloat) {
        let yBottom = startFromY
        let xLeft =  PageLayout.leftMargin + self.getColumnXOffset(column: column)
        let width = self.getColumnWidth(column: column)
        let height = PageLayout.defaultRowHeight * size
        let rect = NSMakeRect(xLeft, yBottom, width, height)
        if row % 2 == 1{
            fillCellBackground(x: xLeft,
                               y: yBottom - PageLayout.gridPadding,
                               width:  width,
                               height: height + 2 * PageLayout.gridPadding,
                               color: lightCellColor)
        }
        drawItemBorder(xLeft, yBottom, height, width)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    fileprivate func drawItemBorder(_ xLeft: CGFloat, _ yBottom: CGFloat, _ height: CGFloat, _ width: CGFloat) {
        drawPath(from: NSMakePoint(xLeft, yBottom + PageLayout.gridPadding + height),
                 to: NSMakePoint(xLeft + width, yBottom + PageLayout.gridPadding + height)) // TOP
        drawPath(from: NSMakePoint(xLeft, yBottom - PageLayout.gridPadding),
                 to: NSMakePoint(xLeft + width, yBottom - PageLayout.gridPadding)) // BOTTOM
        drawPath(from: NSMakePoint(xLeft, yBottom + PageLayout.gridPadding + height),
                 to: NSMakePoint(xLeft, yBottom - PageLayout.gridPadding)) // LEFT
        drawPath(from: NSMakePoint(xLeft + width , yBottom + PageLayout.gridPadding + height), // RIGHT
            to: NSMakePoint(xLeft + width, yBottom - PageLayout.gridPadding))
    }
    
   
}
