//
//  AbstractLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import AppKit


class AbstractLayout {
    let debug: Bool
    let debugColor = NSColor.random
    
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
    
    func drawPath(from: NSPoint, to: NSPoint) {
        let path = NSBezierPath()
        NSColor.lightGray.set()
        path.move(to: from)
        path.line(to: to)
        path.lineWidth = 0.5
        path.stroke()
    }
}
