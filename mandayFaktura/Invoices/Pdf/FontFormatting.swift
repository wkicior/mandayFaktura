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
    let fontAttributesCenter: [NSAttributedStringKey: Any]
    let fontAttributesBoldCenter: [NSAttributedStringKey: Any]
    let fontAttributesPageNumber: [NSAttributedStringKey: Any]

    
    private let paragraphStyleLeft = NSMutableParagraphStyle()
    private let paragraphStyleCenter = NSMutableParagraphStyle()
    private let pageNumParagraphStyle = NSMutableParagraphStyle()
    
    private let fontBold = NSFont(name: "Helvetica Bold", size: 11.0)
    private let font = NSFont(name: "Helvetica", size: 11.0)
    private let pageNumFont = NSFont(name: "Helvetica", size: 15.0)
  
    
    init () {
        paragraphStyleLeft.alignment = .left
        paragraphStyleCenter.alignment = .center
        pageNumParagraphStyle.alignment = .center

        fontAttributesBoldLeft = [
            NSAttributedStringKey.font: fontBold ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:paragraphStyleLeft
        ]
        
        
        fontAttributesCenter = [
            NSAttributedStringKey.font: font ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:paragraphStyleCenter
        ]
        
        fontAttributesBoldCenter = [
            NSAttributedStringKey.font: fontBold ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:paragraphStyleCenter
        ]
        
        fontAttributesPageNumber = [
            NSAttributedStringKey.font: pageNumFont ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:pageNumParagraphStyle,
            NSAttributedStringKey.foregroundColor: NSColor.darkGray
        ]
    }
}
