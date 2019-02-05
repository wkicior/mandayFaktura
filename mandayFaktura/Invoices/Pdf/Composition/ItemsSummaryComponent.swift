//
//  ItemsSummaryLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class ItemsSummaryComponent : AbstractComponent {
    var yPosition: CGFloat = CGFloat(0) //yPosition marks bottom border of text rectangle - it does not include bottom gridPadding
    static let height = defaultRowHeight + 2 * AbstractComponent.gridPadding
    
    let summaryData: [String]
    init(summaryData: [String], yTopPosition: CGFloat) {
        self.yPosition = yTopPosition - ItemsSummaryComponent.height
        self.summaryData = summaryData
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw() {
        (0 ..< summaryData.count).forEach({col in  drawItemsSummaryCell(content: summaryData[col], column: col)})
    }
    
    private func drawItemsSummaryCell(content: String, column: Int) {
        let shift = 4
        let yBottom = yPosition - AbstractComponent.gridPadding
        let xLeft = InvoicePageComposition.leftMargin + getColumnXOffset(column: column + shift)
        let width = self.getColumnWidth(column: column + shift)
        fillCellBackground(x: xLeft, y: yBottom, width: width, height: ItemsSummaryComponent.height, color: darkHeaderColor)
        let rect = NSMakeRect(xLeft, yBottom + AbstractComponent.gridPadding, width, ItemsSummaryComponent.height - 2 * AbstractComponent.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
}
