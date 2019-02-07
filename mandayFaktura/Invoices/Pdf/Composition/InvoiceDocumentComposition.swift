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
        for itemCounter in 0 ..< self.invoice.items.count {
            let properties = [(itemCounter + 1).description] + self.invoice.items[itemCounter].propertiesForDisplay
            let itemTableComponent: ItemTableRowComponent = ItemTableRowComponent(tableData: properties, withBackground: itemCounter % 2 != 0)
            invoicePageComposition.withItemTableRowComponent(itemTableComponent)
        }
        pagesWithTableData.append(invoicePageComposition)
        let lastPage:InvoicePageCompositionBuilder = pagesWithTableData.last!
        let itemsSummaryLayout = ItemsSummaryComponent(summaryData: ["Razem:"] + invoice.propertiesForDisplay)
        let vatBreakdownTableData = getVatBreakdownTableData()
        let paymentSummary = PaymentSummaryComponent(content: invoice.printedPaymentSummary)
        lastPage.withItemTableRowComponent(itemsSummaryLayout)
            .withItemTableRowComponent(vatBreakdownTableData)
            .withSummaryComponents(paymentSummary)
            .withSummaryComponents(NotesComponent(content: invoice.notes))
        return pagesWithTableData.map({page in page.build()})
    }
    
    fileprivate func minimumPageComposition(_ copyTemplate: CopyTemplate) -> InvoicePageCompositionBuilder {
        return anInvoicePageComposition()
            .withHeaderComponent(HeaderComponent(content: invoice.printedHeader))
            .withHeaderComponent(CopyLabelComponent(content: copyTemplate.rawValue))
            .withHeaderComponent(HeaderInvoiceDatesComponent(content: invoice.printedDates))
            .withCounterpartyComponent(SellerComponent(content: invoice.seller.printedSeller))
            .withCounterpartyComponent(BuyerComponent(content: invoice.buyer.printedBuyer))
            .withItemTableRowComponent(ItemTableHeaderComponent(headerData: InvoiceItem.itemColumnNames))
    }
    
    func getVatBreakdownTableData() -> VatBreakdownComponent {
        var breakdownTableData: [[String]] = []
        for breakdownIndex in 0 ..< self.invoice.vatBreakdown.entries.count {
            let breakdown = self.invoice.vatBreakdown.entries[breakdownIndex]
            breakdownTableData.append(breakdown.propertiesForDisplay)
        }
        return VatBreakdownComponent(breakdownLabel: "W tym:", breakdownTableData: breakdownTableData)
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

