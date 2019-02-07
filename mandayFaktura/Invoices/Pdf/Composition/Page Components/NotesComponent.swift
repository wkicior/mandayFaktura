//
//  NotesLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class NotesComponent : AbstractComponent, PageComponent {
    var height = CGFloat(100.0) //TODO should be dynamic
    
    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw(at: NSPoint) {
        let yBottom = at.y - height
        let width = InvoicePageComposition.pdfWidth - InvoicePageComposition.rightMargin
        markBackgroundIfDebug(at.x, yBottom, width, self.height)
        let rect = NSMakeRect(at.x, yBottom, width, self.height)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesLeft)
    }
}
