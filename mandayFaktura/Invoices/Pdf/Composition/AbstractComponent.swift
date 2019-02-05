//
//  AbstractLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit


class AbstractComponent {
    let debug: Bool
    let debugColor = NSColor.random
    let fontFormatting = FontFormatting()
    let lightCellColor = NSColor.fromRGB(red: 215, green: 233, blue: 246)
    let darkHeaderColor =  NSColor.fromRGB(red: 90, green: 164, blue: 218)
    
    let itemsTableWidth =  CGFloat(728)
    
    let itemColumnsWidths = [CGFloat(0.05), CGFloat(0.3), CGFloat(0.1), CGFloat(0.05), CGFloat(0.1), CGFloat(0.1), CGFloat(0.1), CGFloat(0.1), CGFloat(0.1)]

    static let defaultRowHeight = CGFloat(14)
    static let gridPadding = CGFloat(5)
    
    init(debug: Bool) {
       self.debug = debug
    }
    
    func markBackgroundIfDebug(_ xPosition: CGFloat, _ yPosition: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        if (debug) {
            let rectBackground = NSMakeRect(xPosition, yPosition, width, height)
            debugColor.set()
            __NSRectFill(rectBackground)
        }
    }
    
    func fillCellBackground(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: NSColor) {
        let rectBackground = NSMakeRect(x, y, width, height)
        color.set()
        __NSRectFill(rectBackground)
    }
    
    func drawPath(from: NSPoint, to: NSPoint) {
        let path = NSBezierPath()
        NSColor.lightGray.set()
        path.move(to: from)
        path.line(to: to)
        path.lineWidth = 0.5
        path.stroke()
    }
    
    func getColumnWidth(column: Int) -> CGFloat {
        return itemColumnsWidths[column] * itemsTableWidth
    }
    
    func getColumnXOffset(column: Int) -> CGFloat {
        let safeColumnNo = min(column, itemColumnsWidths.count)
        return self.itemColumnsWidths.prefix(upTo: safeColumnNo).reduce(0, +) * itemsTableWidth
    }
}
