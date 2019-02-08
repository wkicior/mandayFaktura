//
//  ItemsSummaryLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class ItemsSummaryComponent : AbstractComponent, PageComponent {
    let height = defaultRowHeight + 2 * AbstractComponent.gridPadding
    var position: NSPoint = NSPoint(x: 0, y: 0)
    let summaryData: [String]
    init(summaryData: [String]) {
        self.summaryData = ["Razem:"] + summaryData
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw(at: NSPoint) {
        self.position = at
        (0 ..< summaryData.count).forEach({col in  drawItemsSummaryCell(content: summaryData[col], column: col)})
    }
    
    private func drawItemsSummaryCell(content: String, column: Int) {
        let shift = 4
        let yBottom = self.position.y - height
        let xLeft = self.position.x + getColumnXOffset(column: column + shift)
        let width = self.getColumnWidth(column: column + shift)
        fillCellBackground(x: xLeft, y: yBottom, width: width, height: height, color: darkHeaderColor)
        drawBorder(xLeft, yBottom, height, width)
        let rect = NSMakeRect(xLeft, yBottom + AbstractComponent.gridPadding, width, height - 2 * AbstractComponent.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
}
