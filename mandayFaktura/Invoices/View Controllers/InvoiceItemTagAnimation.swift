//
//  InvoiceItemTagAnimation.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 26.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa


class InvoiceItemTagAnimation {
    let layer: CALayer
    let animationLayer = CALayer()
    init(layer: CALayer) {
        self.layer = layer
        initializeLayer()
    }
    
    func initializeLayer(){
        animationLayer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        animationLayer.position = CGPoint(x: 20, y: 20)
        animationLayer.backgroundColor = NSColor.systemBlue.cgColor
        animationLayer.cornerRadius = 10
        self.layer.addSublayer(animationLayer)
    }
    
    func start() {
        animationLayer.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "position")
        let startingPoint = NSValue(point: NSPoint(x: 95, y: 185))
        let endingPoint = NSValue(point: NSPoint(x: 120, y: 185))
        animation.fromValue = startingPoint
        animation.toValue = endingPoint
        animation.duration = 0.5
        
        // Callback function
        CATransaction.setCompletionBlock {
            let index = self.layer.sublayers?.index{a in self.animationLayer.isEqual(a)}
            self.layer.sublayers?.remove(at: index!)
        }
        animationLayer.add(animation, forKey: "linearMovement")
        CATransaction.commit()
    }
}
