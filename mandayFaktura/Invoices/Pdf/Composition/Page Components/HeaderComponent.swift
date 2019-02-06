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
    var height: CGFloat {
        get {
            return CGFloat(42.0)
        }
    }
    
    let yPosition: CGFloat
    /*{
        get {
            return CGFloat(930 + 42.0) //TODO: inject this
        }
    }*/
    
    let xPosition: CGFloat
    /*{
        get {
            return 1/2 * InvoicePageComposition.pdfWidth + CGFloat(100.0) //TODO: inject this
        }
    }*/

    let content: String
    init(xPosition: CGFloat, yPosition: CGFloat, content: String) {
        self.yPosition = yPosition
        self.xPosition = xPosition
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw() {
        let yBottom = yPosition - height
        let width = 1/2 * InvoicePageComposition.pdfWidth
        markBackgroundIfDebug(xPosition, yBottom, width, height)
        let rect = NSMakeRect(xPosition, yBottom, width, height)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesHeaderLeft)
    }
}
