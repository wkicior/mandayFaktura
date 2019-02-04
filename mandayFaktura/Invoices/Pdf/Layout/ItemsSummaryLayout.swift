//
//  ItemsSummaryLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class ItemsSummaryLayout : AbstractLayout {
    var yPosition: CGFloat = CGFloat(0) //yPosition marks bottom border of text rectangle - it does not include bottom gridPadding
    static let height = PageLayout.defaultRowHeight + 2 * PageLayout.gridPadding
    
    let summaryData: [String]
    init(summaryData: [String], yPosition: CGFloat) {
        self.yPosition = yPosition - ItemsSummaryLayout.height
        self.summaryData = summaryData
        super.init(debug: PageLayout.debug)
    }
    
    func draw() {
        (0 ..< summaryData.count).forEach({col in  drawItemsSummaryCell(content: summaryData[col], column: col)})
    }
    
    private func drawItemsSummaryCell(content: String, column: Int) {
        let shift = 4
        let yBottom = yPosition - PageLayout.gridPadding
        let xLeft = PageLayout.leftMargin + getColumnXOffset(column: column + shift)
        let width = self.getColumnWidth(column: column + shift)
        fillCellBackground(x: xLeft, y: yBottom, width: width, height: ItemsSummaryLayout.height, color: darkHeaderColor)
        let rect = NSMakeRect(xLeft, yBottom + PageLayout.gridPadding, width, ItemsSummaryLayout.height - 2 * PageLayout.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
}
