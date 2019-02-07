//
//  VatBreakdownLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class VatBreakdownComponent : AbstractComponent {
    var yPosition: CGFloat = CGFloat(0)
    private static let rowHeight = AbstractComponent.defaultRowHeight + AbstractComponent.gridPadding * 2
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
        return CGFloat(first) * VatBreakdownComponent.rowHeight
    }
    
    func draw() {
        drawVatBreakdownCell(content: breakdownLabel, row: 0, column: -1)
        for i in 0 ..< breakdownTableData.count {
            for j in 0 ..< breakdownTableData[i].count {
                drawVatBreakdownCell(content: breakdownTableData[i][j], row: i,column: j)
            }
        }
    }
    
    private func drawVatBreakdownCell(content: String, row: Int, column: Int) {
        let shift = 5
        let yBottom = self.yPosition - AbstractComponent.gridPadding - heightUpTo(first: row)
        let xLeft = InvoicePageComposition.leftMargin + getColumnXOffset(column: column + shift)
        let width = getColumnWidth(column: column + shift)
        if row % 2 == 1{
            fillCellBackground(x: xLeft, y: yBottom, width:  width, height: VatBreakdownComponent.rowHeight, color: lightCellColor)
        }
        drawBorder(xLeft, yBottom, VatBreakdownComponent.rowHeight, width)

        let rect = NSMakeRect(xLeft, yBottom + AbstractComponent.gridPadding, width, VatBreakdownComponent.rowHeight - 2 * AbstractComponent.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
}
