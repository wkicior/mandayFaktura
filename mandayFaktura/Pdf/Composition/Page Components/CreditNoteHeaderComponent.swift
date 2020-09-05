//
//  File.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03/09/2020.
//  Copyright © 2020 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit

class CreditNoteHeaderComponent :  AbstractComponent, PageComponent {
    var height: CGFloat {
        get {
            return CGFloat(42.0)
        }
    }

    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw(at: NSPoint) {
        let yBottom = at.y - height
        let width = InvoicePageComposition.pdfWidth - InvoicePageComposition.leftMargin - InvoicePageComposition.rightMargin
        markBackgroundIfDebug(at.x, yBottom, width, height)
        let rect = NSMakeRect(at.x, yBottom, width, height)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesHeaderLeft)
    }
}
