//
//  NotesLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class NotesLayout : AbstractLayout {
    var height = CGFloat(100.0) //TODO should be dynamic
    var yPosition = CGFloat(0)
    
    let content: String
    init(content: String, topYPosition: CGFloat) {
        self.yPosition = topYPosition - height
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw() {       
        let xPosition = InvoicePageComposition.leftMargin
        let width = InvoicePageComposition.pdfWidth - InvoicePageComposition.rightMargin
        markBackgroundIfDebug(xPosition, self.yPosition, width, self.height)
        let rect = NSMakeRect(xPosition, self.yPosition, width, self.height)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesLeft)
    }
}
