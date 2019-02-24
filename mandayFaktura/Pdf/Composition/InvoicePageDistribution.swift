//
//  InvoicePageDistribution.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 08.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class InvoicePageDistribution: DocumentPageDistribution {
    let copyTemplate: CopyTemplate
    let invoice: Invoice
    
    var pagesWithTableData: [InvoicePageCompositionBuilder] = []
    var currentPageComposition: InvoicePageCompositionBuilder?
    
    init (copyTemplate: CopyTemplate, invoice: Invoice) {
        self.copyTemplate = copyTemplate
        self.invoice = invoice
    }
    
    fileprivate func addPageNumbering() {
        if (pagesWithTableData.count > 1) {
            (0 ..< pagesWithTableData.count)
                .forEach({page in pagesWithTableData[page].withPageNumberingComponent(PageNumberingComponent(page: page + 1, of: pagesWithTableData.count))})
        }
    }
    
    func distributeDocumentOverPageCompositions() -> [InvoicePageComposition] {
        self.initNewPageWithMinimumConposition(copyTemplate)
        distributeItemTableRow()
        distributeVatBreakdown()
        extractedFunc()
        pagesWithTableData.append(currentPageComposition!)
        addPageNumbering()
        return pagesWithTableData.map({page in page.build()})
    }
   
    fileprivate func distributeVatBreakdown() {
        let itemsSummaryLayout = ItemsSummaryComponent(summaryData: invoice.propertiesForDisplay)
        let vatBreakdownTableData = getVatBreakdownComponent()
        appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdown(items: [itemsSummaryLayout, vatBreakdownTableData])
    }
    
    fileprivate func extractedFunc() {
        let paymentSummary = PaymentSummaryComponent(content: invoice.printedPaymentSummary)
        appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: paymentSummary)
        appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: NotesComponent(content: invoice.notes))
    }
    
    fileprivate func distributeItemTableRow() {
        currentPageComposition!.withItemTableRowComponent(ItemTableHeaderComponent(headerData: InvoiceItem.itemColumnNames))
        for itemCounter in 0 ..< self.invoice.items.count {
            let properties = [(itemCounter + 1).description] + self.invoice.items[itemCounter].propertiesForDisplay
            let itemTableComponent: ItemTableRowComponent = ItemTableRowComponent(tableData: properties, withBackground: itemCounter % 2 != 0)
            appendIfFitsOtherwiseCreateNewPageComposition(item: itemTableComponent)
        }
    }
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageComposition(item: PageComponent) {
        if (currentPageComposition!.canFit(pageComponent:item)) {
            currentPageComposition!.withItemTableRowComponent(item)
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            self.initNewPageWithMinimumConposition(copyTemplate)
            currentPageComposition!.withItemTableRowComponent(ItemTableHeaderComponent(headerData: InvoiceItem.itemColumnNames))
            currentPageComposition!.withItemTableRowComponent(item)
        }
    }
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdown(items: [PageComponent]) {
        if (currentPageComposition!.canFit(pageComponents: items)) {
            items.forEach({item in currentPageComposition!.withItemTableRowComponent(item)})
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            self.initNewPageWithMinimumConposition(copyTemplate)
            items.forEach({item in currentPageComposition!.withItemTableRowComponent(item)})
        }
    }
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: PageComponent) {
        if (currentPageComposition!.canFit(pageComponent:item)) {
            currentPageComposition!.withSummaryComponents(item)
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            self.initNewPageWithMinimumConposition(copyTemplate)
            currentPageComposition!.withSummaryComponents(item)
        }
    }
    
    fileprivate func initNewPageWithMinimumConposition(_ copyTemplate: CopyTemplate) {
        self.currentPageComposition =  anInvoicePageComposition()
            .withHeaderComponent(HeaderComponent(content: invoice.printedHeader))
            .withHeaderComponent(CopyLabelComponent(content: copyTemplate.rawValue))
            .withHeaderComponent(HeaderInvoiceDatesComponent(content: invoice.printedDates))
            .withCounterpartyComponent(SellerComponent(content: invoice.seller.printedSeller))
            .withCounterpartyComponent(BuyerComponent(content: invoice.buyer.printedBuyer))
    }
    
    private func getVatBreakdownComponent() -> VatBreakdownComponent {
        var breakdownTableData: [[String]] = []
        for breakdownIndex in 0 ..< self.invoice.vatBreakdown.entries.count {
            let breakdown = self.invoice.vatBreakdown.entries[breakdownIndex]
            breakdownTableData.append(breakdown.propertiesForDisplay)
        }
        return VatBreakdownComponent(breakdownTableData: breakdownTableData)
    }

}
