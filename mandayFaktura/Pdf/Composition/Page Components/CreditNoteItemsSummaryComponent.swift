//
//  CreditNoteItemsSummaryComponent.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 26.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class CreditNoteItemsSummaryComponent : AbstractComponent, PageComponent {
    var position: NSPoint = NSPoint(x: 0, y: 0)
    let summaryData: [String]
    let rowsCount: Int
    init(summaryData: [String], isI10n: Bool) {
        self.summaryData = ["Korekta:".appendI10n("Change:", isI10n)] + summaryData
        self.rowsCount = isI10n ? 2 : 1
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
        drawBorder(xLeft, yBottom, height, width)
        let rect = NSMakeRect(xLeft, yBottom + AbstractComponent.gridPadding, width, height - 2 * AbstractComponent.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldCenter)
    }
    
    var height: CGFloat {
        return CGFloat(self.rowsCount) * (AbstractComponent.defaultRowHeight + 2 * AbstractComponent.gridPadding)
    }
}
