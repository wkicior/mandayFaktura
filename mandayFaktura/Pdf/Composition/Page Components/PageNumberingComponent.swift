//
//  PageNumberingComponent.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 09.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class PageNumberingComponent: AbstractComponent, PageComponent {
    let height = AbstractComponent.defaultRowHeight
    let content: String
    
    init(page: Int, of: Int, isI10n: Bool, primaryLanguage: Language, secondaryLanguage: Language?) {
        let secondLanguageContent: String = "PDF_PAGE".i18n(language: secondaryLanguage ?? primaryLanguage, defaultContent: "Strona") + " " + String(page) + " " + "PDF_OF".i18n(language: secondaryLanguage ?? primaryLanguage, defaultContent: "z") + " " + String(of)
        let primaryLanguageContent: String = "PDF_PAGE".i18n(language: primaryLanguage, defaultContent: "Page") + " " + String(page) + " " + "PDF_OF".i18n(language: primaryLanguage, defaultContent: "of") + " " + String(of)
        self.content = secondLanguageContent.appendI10n(primaryLanguageContent, secondaryLanguage != nil)
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw(at: NSPoint) {
        let yBottom = at.y - height
        let width = InvoicePageComposition.pdfWidth / 4 - InvoicePageComposition.rightMargin
        let rect = NSMakeRect(at.x, yBottom, width, height)
        markBackgroundIfDebug(at.x,  yBottom, width, height)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesRight)
    }
}
