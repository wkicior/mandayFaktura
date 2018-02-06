//
//  BasePdfPage.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz

class BasePDFPage :PDFPage{
    var pageNumber = 1
    let pageLayout = PageLayout()
   
    
    func drawLine( fromPoint:NSPoint,  toPoint:NSPoint){
        let path = NSBezierPath()
        NSColor.lightGray.set()
        path.move(to: fromPoint)
        path.line(to: toPoint)
        path.lineWidth = 0.5
        path.stroke()
    }
    
    override func bounds(for box: PDFDisplayBox) -> NSRect {
        return NSMakeRect(0, 0, self.pageLayout.pdfWidth, self.pageLayout.pdfHeight)
    }
    
    
    init(pageNumber:Int) {
        super.init()
        self.pageNumber = pageNumber
    }
    
}
