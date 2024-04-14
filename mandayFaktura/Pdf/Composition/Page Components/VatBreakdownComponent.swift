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
    let minRowsCount: Int
    var position: NSPoint = NSPoint(x: 0, y: 0)
    
    init(breakdownTableData: [[String]], isI10n: Bool, primaryLanguage: Language, secondaryLanguage: Language?) {
        self.breakdownLabel = "PDF_INCLUDING".i18n(primaryLanguage: primaryLanguage, secondaryLanguage: secondaryLanguage, defaultContent: "W tym:".appendI10n("Including:", isI10n))
        self.breakdownTableData = breakdownTableData
        self.minRowsCount = isI10n || secondaryLanguage != nil ? 2 : 1
        super.init(debug: InvoicePageComposition.debug)
    }
    
    var height: CGFloat {
        get {
            return heightUpTo(first: max(self.breakdownTableData.count, minRowsCount))
        }
    }
    
    fileprivate func heightUpTo(first: Int) -> CGFloat {
        return (CGFloat(first)) * VatBreakdownComponent.rowHeight
    }
    
    func draw(at: NSPoint) {
        self.position = at
        drawbreakdownLabelCell()
        let isOneItemWithBiggerMinRowsCount = self.minRowsCount > 1 && breakdownTableData.count == 1
        for i in 0 ..< breakdownTableData.count {
            for j in 0 ..< breakdownTableData[i].count {
                drawVatBreakdownCell(content: breakdownTableData[i][j], row: i,column: j, rowsCount: isOneItemWithBiggerMinRowsCount ? 2 : 1)
                
            }
        }
    }
    
    private func drawbreakdownLabelCell() {
        let shift = 4
        let yBottom = self.position.y - height
        let xLeft = self.position.x + getColumnXOffset(column: shift)
        let width = getColumnWidth(column: shift)
        drawBorder(xLeft, yBottom, height, width)
        let rect = NSMakeRect(xLeft, yBottom + AbstractComponent.gridPadding, width, height - 2 * AbstractComponent.gridPadding)
        self.breakdownLabel.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
    private func drawVatBreakdownCell(content: String, row: Int, column: Int, rowsCount: Int) {
        let shift = 5
        let yBottom = self.position.y - heightUpTo(first: row + 1) * CGFloat(rowsCount)
        let xLeft = self.position.x + getColumnXOffset(column: column + shift)
        let width = getColumnWidth(column: column + shift)
        if row % 2 == 1{
            fillCellBackground(x: xLeft, y: yBottom, width:  width, height: VatBreakdownComponent.rowHeight * CGFloat(rowsCount), color: lightCellColor)
        }
        drawBorder(xLeft, yBottom, VatBreakdownComponent.rowHeight * CGFloat(rowsCount), width)
        let rect = NSMakeRect(xLeft, yBottom + AbstractComponent.gridPadding, width, VatBreakdownComponent.rowHeight * CGFloat(rowsCount) - 2 * AbstractComponent.gridPadding)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
    
}
