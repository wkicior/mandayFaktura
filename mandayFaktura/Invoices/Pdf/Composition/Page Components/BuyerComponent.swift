//
//  BuyerLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class BuyerComponent : AbstractComponent {
    static let height = CGFloat(90.0)
    static let marginTop = CGFloat(20)
    static let yPosition = CGFloat(930-14.0) - CGFloat(42.0) - marginTop - height
    
    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw() {
        let xPosition = 1/2 * InvoicePageComposition.pdfWidth
        let width = 1/2 * InvoicePageComposition.pdfWidth
        markBackgroundIfDebug(xPosition, SellerComponent.yPosition, width, SellerComponent.height)
        let rect = NSMakeRect(xPosition, SellerComponent.yPosition, width, SellerComponent.height)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
}
