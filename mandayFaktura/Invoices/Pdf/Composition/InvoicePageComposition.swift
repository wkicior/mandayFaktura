//
//  InvoicePageComposition.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

struct InvoicePageComposition {
    static let leftMargin = CGFloat(20.0)
    static let rightMargin = CGFloat(20.0)
    
    static let debug = false
    
    static let pdfHeight = CGFloat(1024.0)
    static let pdfWidth = CGFloat(768.0)
    
    static let headerYPosition = CGFloat(930 + 42.0)
    static let headerXPosition = 1/2 * InvoicePageComposition.pdfWidth + CGFloat(100.0)

    let headerComponents: [PageComponent]
    let counterpartyComponents: [PageComponent]
    let itemTableRowComponents: [PageComponent]
    let summaryComponents: [PageComponent]
    
    func draw() {
        var currentYPosition = InvoicePageComposition.headerYPosition
        for i in 0 ..< headerComponents.count {
            let currentPosition = NSMakePoint(InvoicePageComposition.headerXPosition, currentYPosition)
            headerComponents[i].draw(at: currentPosition)
            currentYPosition = currentPosition.y - headerComponents[i].height
        }
        for i in 0 ..< counterpartyComponents.count {
            let currentPosition = NSMakePoint((i % 2 == 0 ? CGFloat(100) :  1/2 * InvoicePageComposition.pdfWidth), currentYPosition)
            counterpartyComponents[i].draw(at: currentPosition)
            if (i % 2 == 1) {
                currentYPosition = currentPosition.y - counterpartyComponents[i].height
            }
        }
        for i in 0 ..< itemTableRowComponents.count {
            let currentPosition = NSMakePoint(InvoicePageComposition.leftMargin, currentYPosition)
            itemTableRowComponents[i].draw(at: currentPosition)
            currentYPosition = currentPosition.y - itemTableRowComponents[i].height
        }
        for i in 0 ..< summaryComponents.count {
            let currentPosition = NSMakePoint(InvoicePageComposition.leftMargin, currentYPosition)
            summaryComponents[i].draw(at: currentPosition)
            currentYPosition = currentPosition.y - summaryComponents[i].height
        }
    }
    
    func bound() -> NSRect {
        return NSMakeRect(0, 0, InvoicePageComposition.pdfWidth, InvoicePageComposition.pdfHeight)
    }
}

func anInvoicePageComposition() -> InvoicePageCompositionBuilder {
    return InvoicePageCompositionBuilder()
}

class InvoicePageCompositionBuilder {
    var headerComponents: [PageComponent] = []
    var counterpartyComponents: [PageComponent] = []
    var itemTableRowComponents: [PageComponent] = []
    var summaryComponents: [PageComponent] = []
    var notes: NotesComponent?
    
    func withHeaderComponent(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.headerComponents.append(pageComponent)
        return self
    }
    
    func withCounterpartyComponent(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.counterpartyComponents.append(pageComponent)
        return self
    }
    
    func withItemTableRowComponent(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.itemTableRowComponents.append(pageComponent)
        return self
    }
    
    func withSummaryComponents(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.summaryComponents.append(pageComponent)
        return self
    }
    
    func build() -> InvoicePageComposition {
        return InvoicePageComposition(
            headerComponents: headerComponents,
            counterpartyComponents: counterpartyComponents,
            itemTableRowComponents: itemTableRowComponents,
            summaryComponents: summaryComponents)
    }
}
