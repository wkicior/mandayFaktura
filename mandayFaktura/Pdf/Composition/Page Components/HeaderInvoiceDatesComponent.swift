//
//  HeaderInvoiceDatesLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit


class HeaderInvoiceDatesComponent : AbstractComponent, PageComponent {
    static let heightOfDates = CGFloat(30.0)
    static let heightOfLine = CGFloat(12.0)
    var height: CGFloat {
        get {
            return HeaderInvoiceDatesComponent.heightOfDates + HeaderInvoiceDatesComponent.heightOfLine
        }
    }
    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw(at: NSPoint) {
        let width = 1/2 * InvoicePageComposition.pdfWidth
        let yBottom = at.y - height + HeaderInvoiceDatesComponent.heightOfLine
        let rect = NSMakeRect(at.x, yBottom, width, HeaderInvoiceDatesComponent.heightOfDates)
        markBackgroundIfDebug(at.x, yBottom, width, HeaderInvoiceDatesComponent.heightOfDates)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
        drawHeaderHorizontalLine(y: at.y - height)
    }
    
    func drawHeaderHorizontalLine(y: CGFloat) {
        let fromPoint = NSMakePoint(InvoicePageComposition.leftMargin , y)
        let toPoint = NSMakePoint(InvoicePageComposition.pdfWidth - InvoicePageComposition.rightMargin, y)
        drawPath(from: fromPoint, to: toPoint)
    }
}
