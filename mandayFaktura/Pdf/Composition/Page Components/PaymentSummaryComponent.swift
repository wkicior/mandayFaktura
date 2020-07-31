//
//  PaymentSummaryLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class PaymentSummaryComponent : AbstractComponent, PageComponent {
    private static let notesHeight = CGFloat(100.0)
    private static let lineHeight = CGFloat(10.0)
    let height = (CGFloat(5) * (AbstractComponent.defaultRowHeight + 2 * AbstractComponent.gridPadding))
    
    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw(at: NSPoint) {
        let yBottom = at.y - height
        let xLeft = at.x + CGFloat(35)
        drawPaymentSummaryHorizontalLine(at: at)
        let width = 1/2.3 * InvoicePageComposition.pdfWidth
        markBackgroundIfDebug(xLeft, yBottom, width, height)
        markBackgroundIfDebug(xLeft, yBottom, width, PaymentSummaryComponent.notesHeight)
        let rect = NSMakeRect(xLeft, yBottom, width, PaymentSummaryComponent.notesHeight)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawPaymentSummaryHorizontalLine(at: NSPoint) {
        let y = at.y - height + PaymentSummaryComponent.notesHeight + PaymentSummaryComponent.lineHeight
        let fromPoint = NSMakePoint(at.x , y)
        let toPoint = NSMakePoint(InvoicePageComposition.pdfWidth - InvoicePageComposition.rightMargin, y)
        drawPath(from: fromPoint, to: toPoint)
    }
}
