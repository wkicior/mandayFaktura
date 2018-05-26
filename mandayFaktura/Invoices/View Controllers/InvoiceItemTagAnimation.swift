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
    let targetButton: NSButton
    init(layer: CALayer, targetButton: NSButton) {
        self.layer = layer
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
        animation.calculationMode = kCAAnimationLinear
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
        //shadow.shadowOffset =  CGSize(width: 10, height: 10)
        self.targetButton.shadow = shadow
        self.targetButton.shadow?.set()
    }
    
    func stopAnimation() {
        let index = self.layer.sublayers?.index{a in self.animationLayer.isEqual(a)}
        self.layer.sublayers?.remove(at: index!)
        self.targetButton.shadow = nil
    }
    
    var path: CGMutablePath {
        get {
            let result = CGMutablePath()
            result.move(to: CGPoint(x: 90, y: 185))
            result.addCurve(to: CGPoint(x: 120, y: 185), control1: CGPoint(x: 100, y: 200), control2: CGPoint(x: 110, y: 200))
           // path.addCurve(to: CGPoint(x: 280, y: 100), control1: CGPoint(x: 600, y: 500), control2: CGPoint(x:0, y: 500))
            return result
        }
    }
}
