//
//  NSColorExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 16.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

import Quartz

extension NSColor {
    static func fromRGB(red: Double, green: Double, blue: Double, alpha: Double = 100.0) -> NSColor {
        
        let rgbRed = CGFloat(red/255)
        let rgbGreen = CGFloat(green/255)
        let rgbBlue = CGFloat(blue/255)
        let rgbAlpha = CGFloat(alpha/100)
        
        let color = NSColor(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: rgbAlpha)
        return color
    }
}
