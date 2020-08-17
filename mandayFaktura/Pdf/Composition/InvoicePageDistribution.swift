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
    var pagesWithTableData: [InvoicePageCompositionBuilder] = []
    var currentPageComposition: InvoicePageCompositionBuilder?
    let invoice: Invoice
    let invoiceSettings: InvoiceSettings
    
    init (copyTemplate: CopyTemplate, invoice: Invoice, invoiceSettings: InvoiceSettings) {
        self.invoice = invoice
        self.copyTemplate = copyTemplate
        self.invoiceSettings = invoiceSettings
    }

    func distributeDocumentOverPageCompositions() -> [DocumentPageComposition] {
        self.initNewPageWithMinimumComposition(copyTemplate)
        distributeItemTableRow()
        distributeVatBreakdown()
        distributePaymentSummary()
        pagesWithTableData.append(currentPageComposition!)
        addPageNumbering()
        if (invoiceSettings.mandayFakturaCreditEnabled) {
            addMandayFakturaCredit()
        }
        return pagesWithTableData.map({page in page.build()})
    }
}

extension InvoicePageDistribution {
    func initNewPageWithMinimumComposition(_ copyTemplate: CopyTemplate) {
        self.currentPageComposition = anInvoicePageComposition()
            .withHeaderComponent(HeaderComponent(content: invoice.printedHeader))
            .withHeaderComponent(CopyLabelComponent(content: copyTemplate.getI10nValue(isI10n: self.invoice.isInternational())))
            .withHeaderComponent(HeaderInvoiceDatesComponent(content: invoice.printedDates))
            .withCounterpartyComponent(SellerComponent(content: invoice.printedSeller))
            .withCounterpartyComponent(BuyerComponent(content: invoice.printedBuyer))
    }
   
    fileprivate func distributeVatBreakdown() {
        let itemsSummaryLayout = ItemsSummaryComponent(summaryData: invoice.propertiesForDisplay, isI10n: invoice.isInternational())
        let vatBreakdownTableData = getVatBreakdownComponent()
        appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdown(items: [itemsSummaryLayout, vatBreakdownTableData])
    }
    
    fileprivate func distributePaymentSummary() {
        let paymentSummary = PaymentSummaryComponent(content: invoice.printedPaymentSummary)
        appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: paymentSummary)
        appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: NotesComponent(content: invoice.notes))
    }
    
    fileprivate func distributeItemTableRow() {
        currentPageComposition!.withItemTableRowComponent(ItemTableHeaderComponent(headerData:self.invoice.itemColumnNames))
        self.invoice.invoiceItemsPropertiesForDisplay.enumerated()
            .map({ ItemTableRowComponent(tableData: $1, withBackground: $0 % 2 != 0)})
            .forEach { appendIfFitsOtherwiseCreateNewPageComposition(item: $0) }
    }
    
    private func getVatBreakdownComponent() -> VatBreakdownComponent {
        var breakdownTableData: [[String]] = []
        for breakdownIndex in 0 ..< self.invoice.vatBreakdown.entries.count {
            let breakdown = self.invoice.vatBreakdown.entries[breakdownIndex]
            breakdownTableData.append(breakdown.propertiesForDisplay)
        }
        return VatBreakdownComponent(breakdownTableData: breakdownTableData, isI10n: self.invoice.isInternational())
    }
}

extension InvoicePageDistribution {
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageComposition(item: PageComponent) {
        if (currentPageComposition!.canFit(pageComponent:item)) {
            currentPageComposition!.withItemTableRowComponent(item)
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            self.initNewPageWithMinimumComposition(copyTemplate)
            currentPageComposition!.withItemTableRowComponent(ItemTableHeaderComponent(headerData: self.invoice.itemColumnNames))
            currentPageComposition!.withItemTableRowComponent(item)
        }
    }
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdown(items: [PageComponent]) {
        if (currentPageComposition!.canFit(pageComponents: items)) {
            items.forEach({item in currentPageComposition!.withItemTableRowComponent(item)})
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            self.initNewPageWithMinimumComposition(copyTemplate)
            items.forEach({item in currentPageComposition!.withItemTableRowComponent(item)})
        }
    }
    
    func appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: PageComponent) {
        if (currentPageComposition!.canFit(pageComponent:item)) {
            currentPageComposition!.withSummaryComponents(item)
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            self.initNewPageWithMinimumComposition(copyTemplate)
            currentPageComposition!.withSummaryComponents(item)
        }
    }
}

extension InvoicePageDistribution {
    func addPageNumbering() {
        if (pagesWithTableData.count > 1) {
            (0 ..< pagesWithTableData.count)
                .forEach({page in pagesWithTableData[page].withPageNumberingComponent(PageNumberingComponent(page: page + 1, of: pagesWithTableData.count))})
        }
    }
    
    func addMandayFakturaCredit() {
        (0 ..< pagesWithTableData.count)
            .forEach({page in pagesWithTableData[page].withMandayFakturaCreditComponent(MandayFakturaCreditComponent())})
    }
}

