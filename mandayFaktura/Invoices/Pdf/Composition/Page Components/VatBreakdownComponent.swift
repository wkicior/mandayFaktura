//
//  VatBreakdownLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class VatBreakdownComponent : AbstractComponent, PageComponent {
    var yPosition: CGFloat = CGFloat(0)
    private static let rowHeight = AbstractComponent.defaultRowHeight + AbstractComponent.gridPadding * 2
    private let breakdownLabel: String
    let breakdownTableData: [[String]]
    var position: NSPoint = NSPoint(x: 0, y: 0)
    
    init(breakdownTableData: [[String]]) {
        self.breakdownLabel = "W tym:"
        self.breakdownTableData = breakdownTableData
        super.init(debug: InvoicePageComposition.debug)
    }
    
    var height: CGFloat {
        get {
            return heightUpTo(first: self.breakdownTableData.count)
        }
    }
    
    fileprivate func heightUpTo(first: Int) -> CGFloat {
        return (CGFloat(first)) * VatBreakdownComponent.rowHeight
    }
    
    func draw(at: NSPoint) {
        self.position = at
        drawbreakdownLabelCell(content: breakdownLabel)
        for i in 0 ..< breakdownTableData.count {
            for j in 0 ..< breakdownTableData[i].count {
                drawVatBreakdownCell(content: breakdownTableData[i][j], row: i,column: j)
            }
        }
    }
    
    private func drawbreakdownLabelCell(content: String) {
        let shift = 4
        let yBottom = self.position.y - height
        let xLeft = self.position.x + getColumnXOffset(column: shift)
        let width = getColumnWidth(column: shift)
        drawBorder(xLeft, yBottom, height, width)
        let rect = NSMakeRect(xLeft, yBottom + AbstractComponent.gridPadding, width, height - 2 * AbstractComponent.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    private func drawVatBreakdownCell(content: String, row: Int, column: Int) {
        let shift = 5
        let yBottom = self.position.y - heightUpTo(first: row + 1)
        let xLeft = self.position.x + getColumnXOffset(column: column + shift)
        let width = getColumnWidth(column: column + shift)
        if row % 2 == 1{
            fillCellBackground(x: xLeft, y: yBottom, width:  width, height: VatBreakdownComponent.rowHeight, color: lightCellColor)
        }
        drawBorder(xLeft, yBottom, VatBreakdownComponent.rowHeight, width)
        let rect = NSMakeRect(xLeft, yBottom + AbstractComponent.gridPadding, width, VatBreakdownComponent.rowHeight - 2 * AbstractComponent.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
}
