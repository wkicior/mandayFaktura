//
//  CopyLabelLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit

class CopyLabelComponent : AbstractComponent, PageComponent {    
    var height:CGFloat {
        get {
            return CGFloat(14.0)
        }
    }
    
    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw(at: NSPoint) {
        let yBottom = at.y - height
        let width = 1/2 * InvoicePageComposition.pdfWidth
        let rect = NSMakeRect(at.x, yBottom, width, height)
        markBackgroundIfDebug(at.x,  yBottom, width, height)
        content.uppercased().draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
}
