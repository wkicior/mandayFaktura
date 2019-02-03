//
//  HeaderLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit

class HeaderLayout : AbstractLayout{
    static let yPosition = CGFloat(930)
    let height = CGFloat(42.0)

    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: PageLayout.debug)
    }
    
    func draw() {
        let xPosition = 1/2 * PageLayout.pdfWidth + CGFloat(100.0)
        let width = 1/2 * PageLayout.pdfWidth
        markBackgroundIfDebug(xPosition, HeaderLayout.yPosition, width, height)
        let rect = NSMakeRect(xPosition, HeaderLayout.yPosition, width, height)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesHeaderLeft)
    }
}
