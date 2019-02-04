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
    
    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: PageLayout.debug)
    }
    
    func draw(yPosition: CGFloat) {
        self.yPosition = yPosition
        drawPaymentSummaryHorizontalLine()
        let rect = NSMakeRect(CGFloat(100.0),
                              self.yPosition,
                              1/3 * PageLayout.pdfWidth,
                              CGFloat(80.0))
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
    
    func drawPaymentSummaryHorizontalLine() {
        let y = self.yPosition + CGFloat(90)
        let fromPoint = NSMakePoint(PageLayout.leftMargin , y)
        let toPoint = NSMakePoint(PageLayout.pdfWidth - PageLayout.rightMargin, y)
        drawPath(from: fromPoint, to: toPoint)
    }
}
