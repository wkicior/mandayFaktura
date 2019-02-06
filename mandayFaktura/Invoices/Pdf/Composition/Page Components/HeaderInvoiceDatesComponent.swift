//
//  HeaderInvoiceDatesLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit


class HeaderInvoiceDatesComponent : AbstractComponent {
    static let heightOfDates = CGFloat(30.0)
    static let heightOfLine = CGFloat(12.0)
    static let height = heightOfDates + heightOfLine
    static let yPosition = CGFloat(930-14.0) - height
    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw() {
        let xPosition = 1/2 * InvoicePageComposition.pdfWidth + CGFloat(100.0)
        let width = 1/2 * InvoicePageComposition.pdfWidth
        let yPosition = HeaderInvoiceDatesComponent.yPosition + HeaderInvoiceDatesComponent.heightOfLine
        let rect = NSMakeRect(xPosition, yPosition, width, HeaderInvoiceDatesComponent.heightOfDates)
        markBackgroundIfDebug(xPosition, yPosition, width, HeaderInvoiceDatesComponent.heightOfDates)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
        drawHeaderHorizontalLine()
    }
    
    func drawHeaderHorizontalLine() {
        let y = HeaderInvoiceDatesComponent.yPosition
        let fromPoint = NSMakePoint(InvoicePageComposition.leftMargin , y)
        let toPoint = NSMakePoint(InvoicePageComposition.pdfWidth - InvoicePageComposition.rightMargin, y)
        drawPath(from: fromPoint, to: toPoint)
    }
}
