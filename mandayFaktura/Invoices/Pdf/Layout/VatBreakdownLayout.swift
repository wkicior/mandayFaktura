//
//  VatBreakdownLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class VatBreakdownLayout : AbstractLayout {
    var yPosition: CGFloat = CGFloat(0)
    private static let rowHeight = AbstractLayout.defaultRowHeight + AbstractLayout.gridPadding * 2
    private let breakdownLabel: String
    let breakdownTableData: [[String]]
    
    init(breakdownLabel: String, breakdownTableData: [[String]], topYPosition: CGFloat) {
        self.yPosition = topYPosition
        self.breakdownLabel = breakdownLabel
        self.breakdownTableData = breakdownTableData
        super.init(debug: InvoicePageComposition.debug)
    }
    
    var height: CGFloat {
        get {
            return heightUpTo(first: self.breakdownTableData.count)
        }
    }
    
    fileprivate func heightUpTo(first: Int) -> CGFloat {
        return CGFloat(first) * VatBreakdownLayout.rowHeight
    }
    
    func draw() {
        drawVatBreakdownCell(content: breakdownLabel, row: 0, column: -1)
        for i in 0 ..< breakdownTableData.count {
            for j in 0 ..< breakdownTableData[i].count {
                drawVatBreakdownCell(content: breakdownTableData[i][j], row: i,column: j)
            }
        }
        drawVatBreakdownGrid(rows: breakdownTableData.count, columns: breakdownTableData[0].count)
    }
    
    private func drawVatBreakdownCell(content: String, row: Int, column: Int) {
        let shift = 5
        let yBottom = self.yPosition - AbstractLayout.gridPadding - heightUpTo(first: row)
        let xLeft = InvoicePageComposition.leftMargin + getColumnXOffset(column: column + shift)
        let width = getColumnWidth(column: column + shift)
        if row % 2 == 1{
            fillCellBackground(x: xLeft, y: yBottom, width:  width, height: VatBreakdownLayout.rowHeight, color: lightCellColor)
        }
        let rect = NSMakeRect(xLeft, yBottom + AbstractLayout.gridPadding, width, VatBreakdownLayout.rowHeight - 2 * AbstractLayout.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    private func drawVatBreakdownGrid(rows: Int, columns: Int) {
        (0 ... rows).forEach({r in drawVatBreakdownHorizontalGrid(row: r, of: rows)})
        (0 ... columns + 1).forEach({c in drawVatBreakdownVerticalGrid(cell: c)})
    }
    
    private func drawVatBreakdownVerticalGrid(cell: Int)  {
        let x = InvoicePageComposition.leftMargin + getColumnXOffset(column: cell + 4)
        let fromPoint = NSMakePoint(x, self.yPosition + 2 * VatBreakdownLayout.rowHeight)
        let toPoint = NSMakePoint(x, self.yPosition - height + AbstractLayout.defaultRowHeight + AbstractLayout.gridPadding)
        drawPath(from: fromPoint, to: toPoint)
    }
    
    private func drawVatBreakdownHorizontalGrid(row: Int, of: Int)  {
        let y = self.yPosition - CGFloat(row - 1) * VatBreakdownLayout.rowHeight - AbstractLayout.gridPadding
        let isFirstOrLastRow = row == of || row == 0
        let fromPoint = NSMakePoint(InvoicePageComposition.leftMargin + self.getColumnXOffset(column: isFirstOrLastRow ? 4 : 5) , y)
        let toPoint = NSMakePoint(self.itemsTableWidth + InvoicePageComposition.leftMargin, y)
        drawPath(from: fromPoint, to: toPoint)
    }
    
}
