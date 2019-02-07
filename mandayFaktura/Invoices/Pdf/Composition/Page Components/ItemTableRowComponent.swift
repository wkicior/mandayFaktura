//
//  ItemTableLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class ItemTableRowComponent : AbstractComponent, PageComponent {
    private let tableData: [String]
    private let withBackground: Bool
    
    private var position: NSPoint = NSMakePoint(0, 0) //TODO: make private
    
    init(tableData: [String], withBackground: Bool) {
        self.tableData = tableData
        self.withBackground = withBackground
        super.init(debug: InvoicePageComposition.debug)
    }
    
    var height: CGFloat {
        get {
            let count = tableData[1].count // first index stands for item name which might be more than one row - clean this
            let rowLineCount = max(tableData[1].linesCount(), Int(ceil(CGFloat(CGFloat(count) / 35.0))))
            let rowHeight = CGFloat(rowLineCount) * AbstractComponent.defaultRowHeight + AbstractComponent.gridPadding * 2
            return rowHeight
        }
    }
    
    func draw(at: NSPoint) {
        self.position = at
        (0 ..< tableData.count).forEach({col in drawItemTableCell(column: col)})
    }
    
    private func drawItemTableCell(column: Int) {
        let yBottom = self.position.y - height
        let xLeft =  self.position.x + self.getColumnXOffset(column: column)
        let width = self.getColumnWidth(column: column)
        if withBackground {
            fillCellBackground(x: xLeft, y: yBottom, width: width, height: height, color: lightCellColor)
        }
        drawBorder(xLeft, yBottom, height, width)
        let rect = NSMakeRect(xLeft, yBottom + AbstractComponent.gridPadding, width, height - 2 * AbstractComponent.gridPadding)
        tableData[column].draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
}
