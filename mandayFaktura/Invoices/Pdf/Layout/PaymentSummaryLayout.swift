//
//  PaymentSummaryLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class PaymentSummaryLayout : AbstractLayout {
    var yPosition = CGFloat(0)
    private static let topPadding = (CGFloat(6) * (AbstractLayout.defaultRowHeight + 2 * AbstractLayout.gridPadding))
    private static let notesHeight = CGFloat(80.0)
    private static let lineHeight = CGFloat(10.0)
    static let height = topPadding + notesHeight
    
    let content: String
    init(content: String, topYPosition: CGFloat) {
        self.yPosition = topYPosition - PaymentSummaryLayout.topPadding
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw() {
        drawPaymentSummaryHorizontalLine()
        let xPosition = CGFloat(100.0)
        let width = 1/3 * InvoicePageComposition.pdfWidth
        markBackgroundIfDebug(xPosition, self.yPosition, width, PaymentSummaryLayout.notesHeight)
        let rect = NSMakeRect(xPosition, self.yPosition, width, PaymentSummaryLayout.notesHeight)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawPaymentSummaryHorizontalLine() {
        let y = self.yPosition + PaymentSummaryLayout.notesHeight + PaymentSummaryLayout.lineHeight
        let fromPoint = NSMakePoint(InvoicePageComposition.leftMargin , y)
        let toPoint = NSMakePoint(InvoicePageComposition.pdfWidth - InvoicePageComposition.rightMargin, y)
        drawPath(from: fromPoint, to: toPoint)
    }
}
