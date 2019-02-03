//
//  CopyLabelLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit

class CopyLabelLayout : AbstractLayout{
    private let fontFormatting = FontFormatting()
    static let height = CGFloat(14.0)
    static let yPosition = HeaderLayout.yPosition - height
    static let debug = true
    
    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: PageLayout.debug)
    }
    
    func draw() {
        let xPosition = 1/2 * PageLayout.pdfWidth + CGFloat(100.0)
        let width = 1/2 * PageLayout.pdfWidth
        let rect = NSMakeRect(xPosition, CopyLabelLayout.yPosition, width, CopyLabelLayout.height)
        markBackgroundIfDebug(xPosition,  CopyLabelLayout.yPosition, width, CopyLabelLayout.height)
        content.uppercased().draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
}
