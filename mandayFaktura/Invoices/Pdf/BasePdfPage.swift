//
//  BasePdfPage.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz

class BasePDFPage :PDFPage{
    
    let pageLayout = PageLayout()
   
    override func bounds(for box: PDFDisplayBox) -> NSRect {
        return NSMakeRect(0, 0, PageLayout.pdfWidth, self.pageLayout.pdfHeight)
    }
    
}
