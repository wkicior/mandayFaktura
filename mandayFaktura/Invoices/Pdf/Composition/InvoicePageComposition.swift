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
    let pageComponents: [PageComponent]
    
    let itemTableHeaderComponent: ItemTableHeaderComponent
    let itemTableData: [ItemTableRowComponent]
    let itemsSummary: ItemsSummaryComponent
    let vatBreakdownTableData: VatBreakdownComponent
    let paymentSummary: PaymentSummaryComponent
    let notes: NotesComponent
    
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
        self.itemTableHeaderComponent.draw()
        self.itemTableData.forEach({i in i.draw()})
        self.itemsSummary.draw()
        self.vatBreakdownTableData.draw()
        self.paymentSummary.draw()
        self.notes.draw()
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
    var pageComponents: [PageComponent] = []
    var itemTableHeaderComponent: ItemTableHeaderComponent?
    var itemTableData: [ItemTableRowComponent] = []
    var itemsSummary: ItemsSummaryComponent?
    var vatBreakdownTableData: VatBreakdownComponent?
    var paymentSummary: PaymentSummaryComponent?
    var notes: NotesComponent?
    
    func withHeaderComponent(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.headerComponents.append(pageComponent)
        return self
    }
    
    func withCounterpartyComponent(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.counterpartyComponents.append(pageComponent)
        return self
    }
    
    func withPageComponent(_ pageComponent: PageComponent) -> InvoicePageCompositionBuilder {
        self.pageComponents.append(pageComponent)
        return self
    }
    
    func withItemTableData(_ itemTableData: ItemTableRowComponent) -> InvoicePageCompositionBuilder {
        self.itemTableData.append(itemTableData)
        return self
    }
    
    func withItemTableHeaderComponent(_ itemTableHeaderComponent: ItemTableHeaderComponent) -> InvoicePageCompositionBuilder {
        self.itemTableHeaderComponent = itemTableHeaderComponent
        return self
    }
    
    func withItemsSummary(_ itemsSummary: ItemsSummaryComponent) -> InvoicePageCompositionBuilder {
        self.itemsSummary = itemsSummary
        return self
    }
    
    func withVatBreakdownTableData(_ vatBreakdownTableData: VatBreakdownComponent) -> InvoicePageCompositionBuilder {
        self.vatBreakdownTableData = vatBreakdownTableData
        return self
    }
    
    func withPaymentSummary(_ paymentSummary: PaymentSummaryComponent) -> InvoicePageCompositionBuilder {
        self.paymentSummary = paymentSummary
        return self
    }
    
    func withNotes(_ notes: NotesComponent) -> InvoicePageCompositionBuilder {
        self.notes = notes
        return self
    }
    
    func build() -> InvoicePageComposition {
        return InvoicePageComposition(
            headerComponents: headerComponents,
            counterpartyComponents: counterpartyComponents,
            pageComponents: pageComponents,
            itemTableHeaderComponent: itemTableHeaderComponent ?? ItemTableHeaderComponent(headerData: []),
            itemTableData: itemTableData ,
            itemsSummary: itemsSummary ?? ItemsSummaryComponent(summaryData: [], yTopPosition: CGFloat(0)),
            vatBreakdownTableData: vatBreakdownTableData ?? VatBreakdownComponent(breakdownLabel: "", breakdownTableData: [], topYPosition: CGFloat(0)),
            paymentSummary: paymentSummary ?? PaymentSummaryComponent(content: "", topYPosition: CGFloat(0)),
            notes: notes ?? NotesComponent(content: "", topYPosition: CGFloat(0)))
    }
}
