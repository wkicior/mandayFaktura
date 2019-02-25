//
//  ItemTableHeaderComponent.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 05.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class ItemTableHeaderComponent : AbstractComponent, PageComponent {
    static let paddingTop = CGFloat(41)
    let height = AbstractComponent.defaultRowHeight * 2 + AbstractComponent.gridPadding * 2 + ItemTableHeaderComponent.paddingTop
    
    let headerData: [String]
    let label: String?
    private var position: NSPoint = NSMakePoint(0, 0)
    
    init(headerData: [String], label: String? = nil) {
        self.headerData = headerData
        self.label = label
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw(at: NSPoint) {
        self.position = at
        if label != nil {
            let rect = NSMakeRect(self.position.x, self.position.y - ItemTableHeaderComponent.paddingTop, 500, 21)
            label!.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
        }
        (0 ..< self.headerData.count).forEach({col in drawItemsHeaderCell(content: headerData[col], column: col)})
    }
    
    private func drawItemsHeaderCell(content: String, column: Int) {
        let xLeft = self.position.x + self.getColumnXOffset(column: column)
        let yBottom = self.position.y - height
        let width = getColumnWidth(column: column)
        let cellHeight = height - ItemTableHeaderComponent.paddingTop
        fillCellBackground(x: xLeft,y: yBottom, width: width, height: cellHeight, color: darkHeaderColor)
        self.drawBorder(xLeft, yBottom, cellHeight, width)
        let rect = NSMakeRect(xLeft, yBottom + AbstractComponent.gridPadding, width, cellHeight - 2 * AbstractComponent.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldCenter)
    }
}
