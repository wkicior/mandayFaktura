//
//  ItemTableHeaderComponent.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 05.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class ItemTableHeaderComponent : AbstractComponent {
    static let marginTop = CGFloat(50)
    static let yPosition = SellerComponent.yPosition - marginTop
    static let height = AbstractComponent.defaultRowHeight + AbstractComponent.gridPadding * 2
    
    let headerData: [String]
    
    init(headerData: [String]) {
        self.headerData = headerData
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw() {
        (0 ..< self.headerData.count).forEach({col in drawItemsHeaderCell(content: headerData[col], column: col)})
    }
    
    private func drawItemsHeaderCell(content: String, column: Int) {
        let xLeft = InvoicePageComposition.leftMargin + self.getColumnXOffset(column: column)
        let yBottom = ItemTableRowComponent.yPosition - AbstractComponent.gridPadding
        let width = getColumnWidth(column: column)
        let height = AbstractComponent.defaultRowHeight * 2 + 2 * AbstractComponent.gridPadding
        fillCellBackground(x: xLeft,y: yBottom, width: width, height: height, color: darkHeaderColor)
        self.drawBorder(xLeft, yBottom, height, width)
        let rect = NSMakeRect(xLeft, yBottom + AbstractComponent.gridPadding, width, height - 2 * AbstractComponent.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldCenter)
    }
}
