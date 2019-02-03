//
//  HeaderInvoiceDatesLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit


class HeaderInvoiceDatesLayout : AbstractLayout {
    static let heightOfDates = CGFloat(30.0)
    static let heightOfLine = CGFloat(12.0)
    static let height = heightOfDates + heightOfLine
    static let yPosition = CopyLabelLayout.yPosition - height

    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: PageLayout.debug)
    }
    
    func draw() {
        let xPosition = 1/2 * PageLayout.pdfWidth + CGFloat(100.0)
        let width = 1/2 * PageLayout.pdfWidth
        let yPosition = HeaderInvoiceDatesLayout.yPosition + HeaderInvoiceDatesLayout.heightOfLine
        let rect = NSMakeRect(xPosition, yPosition, width, HeaderInvoiceDatesLayout.heightOfDates)
        markBackgroundIfDebug(xPosition, yPosition, width, HeaderInvoiceDatesLayout.heightOfDates)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
        drawHeaderHorizontalLine()
    }
    
    func drawHeaderHorizontalLine() {
        let y = HeaderInvoiceDatesLayout.yPosition
        let fromPoint = NSMakePoint(PageLayout.leftMargin , y)
        let toPoint = NSMakePoint(PageLayout.pdfWidth - PageLayout.rightMargin, y)
        drawPath(from: fromPoint, to: toPoint)
    }
}
