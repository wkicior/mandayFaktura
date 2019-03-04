//
//  DragOrderingDestination.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 19.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

protocol DestinationViewDelegate {
    func processAction(_ action: NumberingSegmentType, center: NSPoint)
}

class DragOrderingDestination: NSView {
    enum Appearance {
        static let lineWidth: CGFloat = 10.0
    }
    
    var delegate: DestinationViewDelegate?
    
    override func awakeFromNib() {
        setup()
    }
    
    let acceptableTypes: Set<NSPasteboard.PasteboardType> = [OrderingDragSource.type]
    
    func setup() {
        registerForDraggedTypes(Array(acceptableTypes))
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        if isReceivingDrag {
            NSColor.selectedControlColor.set()
            
            let path = NSBezierPath(rect:bounds)
            path.lineWidth = Appearance.lineWidth
            path.stroke()
        }
    }
    
    //we override hitTest so that this view which sits at the top of the view hierachy
    //appears transparent to mouse clicks
    override func hitTest(_ aPoint: NSPoint) -> NSView? {
        return nil
    }
    
    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        var canAccept = false
        let pasteBoard = draggingInfo.draggingPasteboard
        if let types = pasteBoard.types, acceptableTypes.intersection(types).count > 0 {
            canAccept = true
        }
        return canAccept
    }
    
    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? .copy : NSDragOperation()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let allow = shouldAllowDrag(sender)
        return allow
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        let pasteBoard = draggingInfo.draggingPasteboard
        let point = convert(draggingInfo.draggingLocation, from: nil)
        if let types = pasteBoard.types, types.contains(OrderingDragSource.type),
            let action = pasteBoard.string(forType: OrderingDragSource.type) {
            delegate?.processAction(NumberingSegmentType(rawValue: action)!, center:point)
            return true
        }
        return false
        
    }
}



