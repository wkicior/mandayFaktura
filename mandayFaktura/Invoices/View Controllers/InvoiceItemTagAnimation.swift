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
    let sourceButton: NSButton
    let targetButton: NSButton
    init(layer: CALayer, sourceButton: NSButton, targetButton: NSButton) {
        self.layer = layer
        self.sourceButton = sourceButton
        self.targetButton = targetButton

        initializeLayer()
    }
    
    func initializeLayer(){
        animationLayer.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
        animationLayer.position = CGPoint(x: 8, y: 8)
        animationLayer.backgroundColor = NSColor.systemBlue.cgColor
        animationLayer.cornerRadius = 8
        self.layer.addSublayer(animationLayer)
    }
    
    func start() {
        setShadowOnTargetButton()
        animationLayer.removeAllAnimations()
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.calculationMode = CAAnimationCalculationMode.linear
        animation.path = path
     
        animation.duration = 0.5
        
        // Callback function
        CATransaction.setCompletionBlock {
            self.stopAnimation()
        }
        animationLayer.add(animation, forKey: "linearMovement")
        CATransaction.commit()
    }
    
    
    func setShadowOnTargetButton() {
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.systemBlue
        shadow.shadowBlurRadius = 1.2
        self.targetButton.shadow = shadow
        self.targetButton.shadow?.set()
    }
    
    func stopAnimation() {
        let index = self.layer.sublayers?.firstIndex{a in self.animationLayer.isEqual(a)}
        self.layer.sublayers?.remove(at: index!)
        self.targetButton.shadow = nil
    }
    
    var path: CGMutablePath {
        get {
            let result = CGMutablePath()
            let sourceX = self.sourceButton.frame.origin.x + self.sourceButton.frame.size.width / 2
            let sourceY = self.sourceButton.frame.origin.y + self.sourceButton.frame.size.height / 2
            result.move(to: CGPoint(x: sourceX, y: sourceY))
            let targetX = self.targetButton.frame.origin.x + self.targetButton.frame.size.width / 2
            let targetY = self.targetButton.frame.origin.y + self.targetButton.frame.size.height / 2
            result.addCurve(to: CGPoint(x: targetX, y: targetY), control1: CGPoint(x: sourceX + 10, y: sourceY + 20), control2: CGPoint(x: targetX - 10, y: targetY + 20))
            return result
        }
    }
}
