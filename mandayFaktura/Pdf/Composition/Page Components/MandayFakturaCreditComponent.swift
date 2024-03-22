//
//  MandayFakturaCreditComponent.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 07/12/2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class MandayFakturaCreditComponent: AbstractComponent, PageComponent {
    let height = AbstractComponent.defaultRowHeight * 2
    let imgSize = CGFloat(32)
    let imgName = "AppIcon"
    let imgMargin = CGFloat(2)
    let isI10n: Bool
    let primaryLanguage: Language
    let secondaryLanguage: Language?
    
    init(isI10n: Bool, primaryLanguage: Language, secondaryLanguage: Language? = nil) {
        self.isI10n = isI10n
        self.primaryLanguage = primaryLanguage
        self.secondaryLanguage = secondaryLanguage
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw(at: NSPoint) {
        let yBottom = at.y - height
        let width = InvoicePageComposition.pdfWidth * 0.75
        let rectImg = NSMakeRect(at.x, yBottom, imgSize, imgSize)
        let rectText = NSMakeRect(at.x + imgSize + imgMargin, yBottom, width, height)
        markBackgroundIfDebug(at.x,  yBottom, width, height)
        let image = NSImage.init(imageLiteralResourceName: self.imgName)
        image.draw(in: rectImg)
        content.draw(in: rectText, withAttributes: self.fontFormatting.fontAttributesLeftGrey)
    }
    
    var content: String {
        return "PDF_BY_MANDAY_FAKTURA".i18n(primaryLanguage: self.primaryLanguage, secondaryLanguage: self.secondaryLanguage, defaultContent: "Dokument wygenerowany w aplikacji mandayFaktura".appendI10n("This document has been generated with mandayFaktura", self.isI10n)) + "\nhttps://github.com/wkicior/mandayFaktura"
        
    }
    
    
}
