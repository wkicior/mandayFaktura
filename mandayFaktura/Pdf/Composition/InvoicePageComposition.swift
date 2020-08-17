//
//  InvoicePageComposition.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

struct InvoicePageComposition: DocumentPageComposition {
    static let leftMargin = CGFloat(20.0)
    static let rightMargin = CGFloat(20.0)
    
    static let debug = true
    
    static let pdfHeight = CGFloat(1024.0)
    static let pdfWidth = CGFloat(768.0)
    
    static let headerYPosition = CGFloat(972)
    static let headerXPosition = 1/2 * InvoicePageComposition.pdfWidth// + CGFloat(100.0)
    static let marginBottom = CGFloat(52)

    let headerComponents: [PageComponent]
    let counterpartyComponents: [PageComponent]
    let itemTableRowComponents: [PageComponent]
    let summaryComponents: [PageComponent]
    let pageNumberingComponent: PageComponent?
    let mandayFakturaCreditComponent: PageComponent?
    
    func draw() {
        var currentYPosition = drawHeaderComponents()
        currentYPosition = drawCounterpartyComponents(position: currentYPosition)
        currentYPosition = drawItemTableRowComponents(position: currentYPosition)
        drawSummaryComponents(position: currentYPosition)
        pageNumberingComponent?.draw(at: NSPoint(x: InvoicePageComposition.pdfWidth * 0.75, y: InvoicePageComposition.marginBottom))
        mandayFakturaCreditComponent?.draw(at: NSPoint(x: 0 + InvoicePageComposition.leftMargin, y: InvoicePageComposition.marginBottom))
    }
    
    func drawHeaderComponents() -> CGFloat {
        var currentYPosition = InvoicePageComposition.headerYPosition
        for i in 0 ..< headerComponents.count {
            let currentPosition = NSMakePoint(InvoicePageComposition.headerXPosition, currentYPosition)
            headerComponents[i].draw(at: currentPosition)
            currentYPosition = currentPosition.y - headerComponents[i].height
        }
        return currentYPosition
    }
    
    func drawCounterpartyComponents(position: CGFloat) -> CGFloat {
        var currentYPosition = position
        for i in 0 ..< counterpartyComponents.count {
            let currentPosition = NSMakePoint((i % 2 == 0 ? CGFloat(100) :  1/2 * InvoicePageComposition.pdfWidth), currentYPosition)
            counterpartyComponents[i].draw(at: currentPosition)
            if (i % 2 == 1) {
                currentYPosition = currentPosition.y - counterpartyComponents[i].height
            }
        }
        return currentYPosition
    }
    
    func drawItemTableRowComponents(position: CGFloat) -> CGFloat {
        var currentYPosition = position
        for i in 0 ..< itemTableRowComponents.count {
            let currentPosition = NSMakePoint(InvoicePageComposition.leftMargin, currentYPosition)
            itemTableRowComponents[i].draw(at: currentPosition)
            currentYPosition = currentPosition.y - itemTableRowComponents[i].height
        }
        return currentYPosition
    }
    
    func drawSummaryComponents(position: CGFloat)  {
        var currentYPosition = position
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
    var pageNumberingComponent: PageComponent?
    var mandayFakturaCreditComponent: PageComponent?
    
    @discardableResult
    func withHeaderComponent(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.headerComponents.append(pageComponent)
        return self
    }
    
    @discardableResult
    func withCounterpartyComponent(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.counterpartyComponents.append(pageComponent)
        return self
    }
    
    @discardableResult
    func withItemTableRowComponent(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.itemTableRowComponents.append(pageComponent)
        return self
    }
    
    @discardableResult
    func withSummaryComponents(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.summaryComponents.append(pageComponent)
        return self
    }
    
    @discardableResult
    func withPageNumberingComponent(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.pageNumberingComponent = pageComponent
        return self
    }
    
    
    @discardableResult
    func withMandayFakturaCreditComponent(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.mandayFakturaCreditComponent = pageComponent
        return self
    }
    
    func componentsHeight() -> CGFloat {
        let headerHeight = self.headerComponents.map({c in c.height}).reduce(InvoicePageComposition.pdfHeight - InvoicePageComposition.headerYPosition, +)
        let counterPartyHeight = self.counterpartyComponents.first.map({c in c.height})!
        let itemsTableHeight = self.itemTableRowComponents.map({c in c.height}).reduce(0, +)
        let summaryHeight = self.summaryComponents.map({c in c.height}).reduce(0, +)
        return headerHeight + counterPartyHeight + itemsTableHeight + summaryHeight
    }
    
    fileprivate func canFit(height: CGFloat) -> Bool {
        return InvoicePageComposition.pdfHeight - InvoicePageComposition.marginBottom - componentsHeight() - height > 0
    }
    
    func canFit(pageComponent: PageComponent) -> Bool {
        return self.canFit(height: pageComponent.height)
    }
    
    func canFit(pageComponents: [PageComponent]) -> Bool {
        return canFit(height: pageComponents.map({pc in pc.height}).reduce(0, +))
    }
    
    func build() -> InvoicePageComposition {
        return InvoicePageComposition(
            headerComponents: headerComponents,
            counterpartyComponents: counterpartyComponents,
            itemTableRowComponents: itemTableRowComponents,
            summaryComponents: summaryComponents,
            pageNumberingComponent: pageNumberingComponent,
            mandayFakturaCreditComponent: mandayFakturaCreditComponent
        )
    }
}
