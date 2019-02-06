//
//  HeaderLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit

class HeaderComponent :  AbstractComponent, PageComponent {
    let type = PageComponentType.header
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
        let width = 1/2 * InvoicePageComposition.pdfWidth
        markBackgroundIfDebug(at.x, yBottom, width, height)
        let rect = NSMakeRect(at.x, yBottom, width, height)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesHeaderLeft)
    }
}
