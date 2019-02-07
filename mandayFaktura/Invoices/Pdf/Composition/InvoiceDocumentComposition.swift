//
//  InvoiceDocumentComposition.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation


class InvoiceDocumentComposition {
    let invoice:Invoice
    var pagesWithTableData: [InvoicePageCompositionBuilder] = []
    var currentPageComposition: InvoicePageCompositionBuilder?

    init(invoice: Invoice) {
        self.invoice = invoice
    }
    
    fileprivate func getInvoicePagesForCopy(_ copy: CopyTemplate) -> [InvoicePdfPage] {
        return distributeInvoiceOverPageCompositions(copyTemplate: copy)
            .map({pageComposition in InvoicePdfPage(pageComposition: pageComposition)})
    }
    
    fileprivate func distributeInvoiceOverPageCompositions(copyTemplate: CopyTemplate) -> [InvoicePageComposition] {
        pagesWithTableData = []
        currentPageComposition = self.minimumPageComposition(copyTemplate)
        currentPageComposition!.withItemTableRowComponent(ItemTableHeaderComponent(headerData: InvoiceItem.itemColumnNames))
        for itemCounter in 0 ..< self.invoice.items.count {
            let properties = [(itemCounter + 1).description] + self.invoice.items[itemCounter].propertiesForDisplay
            let itemTableComponent: ItemTableRowComponent = ItemTableRowComponent(tableData: properties, withBackground: itemCounter % 2 != 0)
            appendIfFitsOtherwiseCreateNewPageComposition(item: itemTableComponent, copyTemplate: copyTemplate)
        }
        let itemsSummaryLayout = ItemsSummaryComponent(summaryData: ["Razem:"] + invoice.propertiesForDisplay)
        appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdown(item: itemsSummaryLayout, copyTemplate: copyTemplate)
        let vatBreakdownTableData = getVatBreakdownTableData()
        appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdown(item: vatBreakdownTableData, copyTemplate: copyTemplate)
        let paymentSummary = PaymentSummaryComponent(content: invoice.printedPaymentSummary)
        appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: paymentSummary,  copyTemplate: copyTemplate)
        appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: NotesComponent(content: invoice.notes), copyTemplate: copyTemplate)
        pagesWithTableData.append(currentPageComposition!) //TODO append only if it was not just appended :)
        return pagesWithTableData.map({page in page.build()})
    }
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageComposition(item: PageComponent, copyTemplate: CopyTemplate) {
        if (currentPageComposition!.canFit(pageComponent:item)) {
            currentPageComposition!.withItemTableRowComponent(item)
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            currentPageComposition = self.minimumPageComposition(copyTemplate)
            currentPageComposition!.withItemTableRowComponent(ItemTableHeaderComponent(headerData: InvoiceItem.itemColumnNames))
            currentPageComposition!.withItemTableRowComponent(item)
        }
    }
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdown(item: PageComponent, copyTemplate: CopyTemplate) {
        if (currentPageComposition!.canFit(pageComponent:item)) {
            currentPageComposition!.withItemTableRowComponent(item)
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            currentPageComposition = self.minimumPageComposition(copyTemplate)
            currentPageComposition!.withItemTableRowComponent(item)
        }
    }
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: PageComponent, copyTemplate: CopyTemplate) {
        if (currentPageComposition!.canFit(pageComponent:item)) {
            currentPageComposition!.withSummaryComponents(item)
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            currentPageComposition = self.minimumPageComposition(copyTemplate)
            currentPageComposition!.withSummaryComponents(item)
        }
    }
    
    fileprivate func minimumPageComposition(_ copyTemplate: CopyTemplate) -> InvoicePageCompositionBuilder {
        return anInvoicePageComposition()
            .withHeaderComponent(HeaderComponent(content: invoice.printedHeader))
            .withHeaderComponent(CopyLabelComponent(content: copyTemplate.rawValue))
            .withHeaderComponent(HeaderInvoiceDatesComponent(content: invoice.printedDates))
            .withCounterpartyComponent(SellerComponent(content: invoice.seller.printedSeller))
            .withCounterpartyComponent(BuyerComponent(content: invoice.buyer.printedBuyer))
    }
    
    private func getVatBreakdownTableData() -> VatBreakdownComponent {
        var breakdownTableData: [[String]] = []
        for breakdownIndex in 0 ..< self.invoice.vatBreakdown.entries.count {
            let breakdown = self.invoice.vatBreakdown.entries[breakdownIndex]
            breakdownTableData.append(breakdown.propertiesForDisplay)
        }
        return VatBreakdownComponent(breakdownLabel: "W tym:", breakdownTableData: breakdownTableData)
    }
    
    private func getItemTableDataChunksPerPage() -> [[[String]]] {
        var itemTableData: [[String]] = []
        for itemCounter in 0 ..< self.invoice.items.count {
            let properties = [(itemCounter + 1).description] + self.invoice.items[itemCounter].propertiesForDisplay
            itemTableData.append(properties)
        }
        return [itemTableData]
    }
    
    func getInvoicePages(copies: [CopyTemplate]) -> [InvoicePdfPage] {
        return copies.flatMap({copy in getInvoicePagesForCopy(copy)})
    }
}

