//
//  BuyerLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class BuyerComponent : AbstractComponent, PageComponent {
    let height = CGFloat(90.0) + BuyerComponent.paddingTop
    static let paddingTop = CGFloat(20)
    
    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw(at: NSPoint) {
        let yBottom = at.y - height
        let width = 1/2 * InvoicePageComposition.pdfWidth
        markBackgroundIfDebug(at.x, yBottom, width, height - BuyerComponent.paddingTop)
        let rect = NSMakeRect(at.x, yBottom, width, height - BuyerComponent.paddingTop)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
}
