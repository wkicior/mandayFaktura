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
    init(invoice: Invoice) {
        self.invoice = invoice
    }
    
    fileprivate func getInvoicePagesForCopy(_ copy: CopyTemplate) -> [InvoicePdfPage] {
        return distributeInvoiceOverPageCompositions(copyTemplate: copy)
            .map({pageComposition in InvoicePdfPage(pageComposition: pageComposition)})
    }
    
    fileprivate func distributeInvoiceOverPageCompositions(copyTemplate: CopyTemplate) -> [InvoicePageComposition] {
        /*let pagesWithTableData: [InvoicePageCompositionBuilder] = getItemTableDataChunksPerPage().map({itemTableDataChunk in
            let invoicePageComposition = self.minimumPageComposition(copyTemplate)
                .withItemTableData(ItemTableComponent(tableData: itemTableDataChunk))
            //TODO fix NPE on vat breakdown empty
            return invoicePageComposition
        })*/
        var pagesWithTableData: [InvoicePageCompositionBuilder] = []
        let invoicePageComposition = self.minimumPageComposition(copyTemplate)
        var yPosition = ItemTableHeaderComponent.yPosition - ItemTableHeaderComponent.height
        for itemCounter in 0 ..< self.invoice.items.count {
            let properties = [(itemCounter + 1).description] + self.invoice.items[itemCounter].propertiesForDisplay
            let itemTableComponent: ItemTableComponent = ItemTableComponent(tableData: properties, topYPosition: yPosition, withBackground: itemCounter % 2 != 0)
            invoicePageComposition.withItemTableData(itemTableComponent)
            yPosition = itemTableComponent.yPosition - itemTableComponent.height
        }
        pagesWithTableData.append(invoicePageComposition)
        let lastPage:InvoicePageCompositionBuilder = pagesWithTableData.last!
        let itemsSummaryYPosition = yPosition //TODO: clean this
        let itemsSummaryLayout = ItemsSummaryComponent(summaryData: ["Razem:"] + invoice.propertiesForDisplay, yTopPosition: itemsSummaryYPosition)
        let vatBrakdownYPosition = itemsSummaryLayout.yPosition - ItemsSummaryComponent.height
        let vatBreakdownTableData = getVatBreakdownTableData(topYPosition: vatBrakdownYPosition)
        let paymentSummaryYPosition = vatBreakdownTableData.yPosition - vatBreakdownTableData.height
        let paymentSummary = PaymentSummaryComponent(content: invoice.printedPaymentSummary, topYPosition: paymentSummaryYPosition)
        lastPage.withItemsSummary(itemsSummaryLayout)
            .withVatBreakdownTableData(vatBreakdownTableData)
            .withPaymentSummary(paymentSummary)
            .withNotes(NotesComponent(content: invoice.notes, topYPosition: paymentSummary.yPosition))
        return pagesWithTableData.map({page in page.build()})
    }
    
    fileprivate func minimumPageComposition(_ copyTemplate: CopyTemplate) -> InvoicePageCompositionBuilder {
        return anInvoicePageComposition()
            .withHeader(HeaderComponent(content: invoice.printedHeader))
            .withDates(HeaderInvoiceDatesComponent(content: invoice.printedDates))
            .withCopyLabel(CopyLabelComponent(content: copyTemplate.rawValue))
            .withSeller(SellerComponent(content: invoice.seller.printedSeller))
            .withBuyer(BuyerComponent(content: invoice.buyer.printedBuyer))
            .withItemTableHeaderComponent(ItemTableHeaderComponent(headerData: InvoiceItem.itemColumnNames))
    }
    
    func getVatBreakdownTableData(topYPosition: CGFloat) -> VatBreakdownComponent {
        var breakdownTableData: [[String]] = []
        for breakdownIndex in 0 ..< self.invoice.vatBreakdown.entries.count {
            let breakdown = self.invoice.vatBreakdown.entries[breakdownIndex]
            breakdownTableData.append(breakdown.propertiesForDisplay)
        }
        return VatBreakdownComponent(breakdownLabel: "W tym:", breakdownTableData: breakdownTableData, topYPosition: topYPosition)
    }
    
    func getItemTableDataChunksPerPage() -> [[[String]]] {
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

