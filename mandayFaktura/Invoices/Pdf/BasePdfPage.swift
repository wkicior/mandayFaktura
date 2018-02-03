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
    let topMargin = CGFloat(40.0)
    let leftMargin = CGFloat(20.0)
    let rightMargin = CGFloat(20.0)
    let bottomMargin = CGFloat (40.0)
    let textInset = CGFloat(5.0)
    let verticalPadding = CGFloat (10.0)
    
    var pageNumber = 1
    
    var pdfHeight = CGFloat(1024.0)
    var pdfWidth = CGFloat(768.0)
    
    func drawLine( fromPoint:NSPoint,  toPoint:NSPoint){
        let path = NSBezierPath()
        NSColor.lightGray.set()
        path.move(to: fromPoint)
        path.line(to: toPoint)
        path.lineWidth = 0.5
        path.stroke()
    }
    
    func drawPageNumbers() {
        let pageNumFont = NSFont(name: "Helvetica", size: 15.0)
        let pageNumParagraphStyle = NSMutableParagraphStyle()
        pageNumParagraphStyle.alignment = .center
        
        let pageNumFontAttributes = [
            NSAttributedStringKey.font: pageNumFont ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:pageNumParagraphStyle,
            NSAttributedStringKey.foregroundColor: NSColor.darkGray
        ]
        
        let pageNumRect = NSMakeRect(self.pdfWidth/2, CGFloat(15.0), CGFloat(40.0), CGFloat(20.0))
        let pageNumberStr = "\(self.pageNumber)"
        pageNumberStr.draw(in: pageNumRect, withAttributes: pageNumFontAttributes)
        
    }
    
    override func bounds(for box: PDFDisplayBox) -> NSRect {
        return NSMakeRect(0, 0, pdfWidth, pdfHeight)
    }
    
    override func draw(with box: PDFDisplayBox) {
        self.drawPageNumbers()
    }
    
    init(pageNumber:Int) {
        super.init()
        self.pageNumber = pageNumber
    }
    
}
