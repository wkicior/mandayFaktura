//
//  FontFormatting.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz


class FontFormatting {
    let fontAttributesBoldLeft: [NSAttributedStringKey: Any]
    let fontAttributesHeaderLeft: [NSAttributedStringKey: Any]
    let fontAttributesCenter: [NSAttributedStringKey: Any]
    let fontAttributesBoldCenter: [NSAttributedStringKey: Any]

    
    private let paragraphStyleLeft = NSMutableParagraphStyle()
    private let paragraphStyleCenter = NSMutableParagraphStyle()
    
    private let fontBold = NSFont(name: "Helvetica Bold", size: 11.0)
    private let fontHeader = NSFont(name: "Helvetica Bold", size: 16.0)
    private let font = NSFont(name: "Helvetica", size: 11.0)
  
    
    init () {
        paragraphStyleLeft.alignment = .left
        paragraphStyleCenter.alignment = .center

        fontAttributesBoldLeft = [
            NSAttributedStringKey.font: fontBold ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:paragraphStyleLeft,
        ]
        
        fontAttributesHeaderLeft = [
            NSAttributedStringKey.font: fontHeader ?? NSFont.labelFont(ofSize: 18),
            NSAttributedStringKey.paragraphStyle:paragraphStyleLeft,
        ]
        
        fontAttributesCenter = [
            NSAttributedStringKey.font: font ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:paragraphStyleCenter
        ]
        
        fontAttributesBoldCenter = [
            NSAttributedStringKey.font: fontBold ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:paragraphStyleCenter,
        ]
    }
}
