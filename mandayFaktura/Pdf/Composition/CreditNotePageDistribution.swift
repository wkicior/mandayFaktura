//
//  CreditNotePageDistribution.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 08.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class CreditNotePageDistribution: DocumentPageDistribution {
    let copyTemplate: CopyTemplate
    let invoiceFacade: InvoiceFacade = InvoiceFacade()
    var pagesWithTableData: [CreditNotePageCompositionBuilder] = []
    var currentPageComposition: CreditNotePageCompositionBuilder?
    
    let creditNote: CreditNote
    let invoice: Invoice
    let invoiceSettings: InvoiceSettings
   
    init (copyTemplate: CopyTemplate, creditNote: CreditNote, invoiceSettings: InvoiceSettings) {
        self.creditNote = creditNote
        self.copyTemplate = copyTemplate
        self.invoice = self.invoiceFacade.getInvoice(number: self.creditNote.invoiceNumber)
        self.invoiceSettings = invoiceSettings
    }
    
    func distributeDocumentOverPageCompositions() -> [DocumentPageComposition] {
        self.initNewPageWithMinimumComposition(copyTemplate)
        distributeItemBeforeTableRow()
        distributeItemsSummaryBefore()
        
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
extension CreditNotePageDistribution {
    
    fileprivate func distributeVatBreakdown() {
        let itemsSummaryLayout = ItemsSummaryComponent(summaryData: creditNote.propertiesForDisplay)
        let creditNoteDifferenceItemsSummaryLayout = CreditNoteItemsSummaryComponent(summaryData: creditNote.creditNoteDifferencesPropertiesForDisplay(on: self.invoice))

        let vatBreakdownTableData = getVatBreakdownComponent()
        appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdown(items: [itemsSummaryLayout, creditNoteDifferenceItemsSummaryLayout, vatBreakdownTableData])
    }
    
    fileprivate func distributeItemsSummaryBefore() {
        let itemsSummaryLayout = ItemsSummaryComponent(summaryData: invoice.propertiesForDisplay)
        appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdownBefore(items: [itemsSummaryLayout])
    }
    
    fileprivate func distributePaymentSummary() {
        let paymentSummary = PaymentSummaryComponent(content: creditNote.printedPaymentSummary(on: invoice))
        appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: paymentSummary)
        appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: NotesComponent(content: creditNote.reason))
    }
    
    fileprivate func distributeItemTableRow() {
        currentPageComposition!.withItemTableRowComponent(ItemTableHeaderComponent(headerData: InvoiceItem.itemColumnNames, label: "Po korekcie:"))
        for itemCounter in 0 ..< self.creditNote.items.count {
            let properties = [(itemCounter + 1).description] + self.creditNote.items[itemCounter].propertiesForDisplay
            let itemTableComponent: ItemTableRowComponent = ItemTableRowComponent(tableData: properties, withBackground: itemCounter % 2 != 0)
            appendIfFitsOtherwiseCreateNewPageComposition(item: itemTableComponent)
        }
    }
    
    fileprivate func distributeItemBeforeTableRow() {
        currentPageComposition!.withItemBeforeTableRowComponent(ItemTableHeaderComponent(headerData: InvoiceItem.itemColumnNames, label: "Przed korektą:"))
        for itemCounter in 0 ..< invoice.items.count {
            let properties = [(itemCounter + 1).description] + invoice.items[itemCounter].propertiesForDisplay
            let itemTableComponent: ItemTableRowComponent = ItemTableRowComponent(tableData: properties, withBackground: itemCounter % 2 != 0)
            appendIfFitsOtherwiseCreateNewPageCompositionItemBefore(item: itemTableComponent)
        }
    }
    
    func initNewPageWithMinimumComposition(_ copyTemplate: CopyTemplate) {
        self.currentPageComposition = aCreditNotePageComposition()
            .withHeaderComponent(HeaderComponent(content: creditNote.printedHeader + "\n" + invoice.creditedNoteHeader))
            .withHeaderComponent(CopyLabelComponent(content: copyTemplate.rawValue))
            .withHeaderComponent(HeaderInvoiceDatesComponent(content: creditNote.printedDates))
            .withCounterpartyComponent(SellerComponent(content: creditNote.seller.printedSeller))
            .withCounterpartyComponent(BuyerComponent(content: creditNote.buyer.printedBuyer))
    }
    
    private func getVatBreakdownComponent() -> VatBreakdownComponent {
        var breakdownTableData: [[String]] = []
        for breakdownIndex in 0 ..< self.creditNote.differenceVatBreakdown(on: invoice).entries.count {
            let breakdown = self.creditNote.differenceVatBreakdown(on: invoice).entries[breakdownIndex]
            breakdownTableData.append(breakdown.propertiesForDisplay)
        }
        return VatBreakdownComponent(breakdownTableData: breakdownTableData)
    }
}

extension CreditNotePageDistribution {
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageComposition(item: PageComponent) {
        if (currentPageComposition!.canFit(pageComponent:item)) {
            currentPageComposition!.withItemTableRowComponent(item)
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            self.initNewPageWithMinimumComposition(copyTemplate)
            currentPageComposition!.withItemTableRowComponent(ItemTableHeaderComponent(headerData: InvoiceItem.itemColumnNames))
            currentPageComposition!.withItemTableRowComponent(item)
        }
    }
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageCompositionItemBefore(item: PageComponent) {
        if (currentPageComposition!.canFit(pageComponent:item)) {
            currentPageComposition!.withItemBeforeTableRowComponent(item)
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            self.initNewPageWithMinimumComposition(copyTemplate)
            currentPageComposition!.withItemBeforeTableRowComponent(ItemTableHeaderComponent(headerData: InvoiceItem.itemColumnNames))
            currentPageComposition!.withItemBeforeTableRowComponent(item)
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
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdownBefore(items: [PageComponent]) {
        if (currentPageComposition!.canFit(pageComponents: items)) {
            items.forEach({item in currentPageComposition!.withItemBeforeTableRowComponent(item)})
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            self.initNewPageWithMinimumComposition(copyTemplate)
            items.forEach({item in currentPageComposition!.withItemBeforeTableRowComponent(item)})
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

extension CreditNotePageDistribution {
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
