//
//  ItemsSummaryLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class ItemsSummaryLayout : AbstractLayout {
    static let height = CGFloat(90.0)
    static let marginTop = CGFloat(20)
    //static let yPosition = HeaderInvoiceDatesLayout.yPosition - marginTop - height
    var yPosition: CGFloat = CGFloat(0)
    
    let summaryData: [String]
    init(summaryData: [String]) {
        self.summaryData = summaryData
        super.init(debug: PageLayout.debug)
    }
    
    func draw(yPosition: CGFloat) {
        self.yPosition = yPosition - PageLayout.defaultRowHeight - 2 * PageLayout.gridPadding //TODO: clean this
        //self.itemsSummaryYPosition = self.yPosition
        for i in 0 ..< summaryData.count {
            drawItemsSummaryCell(content: summaryData[i], column: i)
        }
    }
    
    private func drawItemsSummaryCell(content: String, column: Int) {
        let shift = 4
        
        let rect = NSMakeRect(PageLayout.leftMargin + getColumnXOffset(column: column + shift),
                              self.yPosition,
                              getColumnWidth(column: column + shift),
                              PageLayout.defaultRowHeight)
        fillCellBackground(x: PageLayout.leftMargin + getColumnXOffset(column: column + shift),
                           y: self.yPosition - PageLayout.gridPadding,
                           width:  self.getColumnWidth(column: column + shift),
                           height: PageLayout.defaultRowHeight + 2 * PageLayout.gridPadding,
                           color: darkHeaderColor)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesCenter)
    }
}
