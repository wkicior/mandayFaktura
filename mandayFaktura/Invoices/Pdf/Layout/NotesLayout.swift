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
    init(content: String) {
        self.content = content
        super.init(debug: PageLayout.debug)
    }
    
    func draw(yPosition: CGFloat) {
        self.yPosition = yPosition
        let rect = NSMakeRect(PageLayout.leftMargin, self.yPosition, PageLayout.pdfWidth - PageLayout.rightMargin, CGFloat(100.0))
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesLeft)
    }
}
