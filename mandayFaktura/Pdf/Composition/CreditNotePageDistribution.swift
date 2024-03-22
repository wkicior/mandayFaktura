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
        let itemsSummaryLayout = ItemsSummaryComponent(summaryData: creditNote.propertiesForDisplay, isI10n: self.creditNote.isInternational())
        let creditNoteDifferenceItemsSummaryLayout = CreditNoteItemsSummaryComponent(summaryData: creditNote.creditNoteDifferencesPropertiesForDisplay(on: self.invoice), isI10n: creditNote.isInternational())

        let vatBreakdownTableData = getVatBreakdownComponent()
        appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdown(items: [itemsSummaryLayout, creditNoteDifferenceItemsSummaryLayout, vatBreakdownTableData])
    }
    
    fileprivate func distributeItemsSummaryBefore() {
        let itemsSummaryLayout = ItemsSummaryComponent(summaryData: invoice.propertiesForDisplay, isI10n: self.creditNote.isInternational())
        appendIfFitsOtherwiseCreateNewPageCompositionVatBreakdownBefore(items: [itemsSummaryLayout])
    }
    
    fileprivate func distributePaymentSummary() {
        let paymentSummary = PaymentSummaryComponent(content: creditNote.printedPaymentSummary(on: invoice))
        appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: paymentSummary)
        appendIfFitsOtherwiseCreateNewPageCompositionPaymentSummary(item: NotesComponent(content: creditNote.reason))
    }
    
    fileprivate func distributeItemTableRow() {
        let label = "Po korekcie".appendI10n("After", self.creditNote.isInternational()) + ":"
        currentPageComposition!.withItemTableRowComponent(ItemTableHeaderComponent(headerData: self.creditNote.itemColumnNames, label: label))
        self.creditNote.invoiceItemsPropertiesForDisplay.enumerated()
            .map({ ItemTableRowComponent(tableData: $1, withBackground: $0 % 2 != 0)})
            .forEach { appendIfFitsOtherwiseCreateNewPageComposition(item: $0) }
    }
    
    fileprivate func distributeItemBeforeTableRow() {
        let label = "Przed korektą".appendI10n("Before", self.creditNote.isInternational()) + ":"
        currentPageComposition!.withItemBeforeTableRowComponent(ItemTableHeaderComponent(headerData: self.creditNote.itemColumnNames, label: label))
        self.invoice.invoiceItemsPropertiesForDisplay.enumerated()
            .map({ ItemTableRowComponent(tableData: $1, withBackground: $0 % 2 != 0)})
            .forEach { appendIfFitsOtherwiseCreateNewPageCompositionItemBefore(item: $0) }
    }
    
    func initNewPageWithMinimumComposition(_ copyTemplate: CopyTemplate) {
        self.currentPageComposition = aCreditNotePageComposition()
            .withHeaderComponent(CreditNoteHeaderComponent(content: creditNote.printedHeader + "\n" + invoice.creditedNoteHeader))
            .withHeaderComponent(CopyLabelComponent(content: copyTemplate.getI10nValue(isI10n: self.creditNote.isInternational())))
            .withHeaderComponent(HeaderInvoiceDatesComponent(content: creditNote.printedDates))
            .withCounterpartyComponent(SellerComponent(content: creditNote.printedSeller))
            .withCounterpartyComponent(BuyerComponent(content: creditNote.printedBuyer))
    }
    
    private func getVatBreakdownComponent() -> VatBreakdownComponent {
        var breakdownTableData: [[String]] = []
        for breakdownIndex in 0 ..< self.creditNote.differenceVatBreakdown(on: invoice).entries.count {
            let breakdown = self.creditNote.differenceVatBreakdown(on: invoice).entries[breakdownIndex]
            breakdownTableData.append(breakdown.propertiesForDisplay)
        }
        return VatBreakdownComponent(breakdownTableData: breakdownTableData, isI10n: self.creditNote.isInternational())
    }
}

extension CreditNotePageDistribution {
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageComposition(item: PageComponent) {
        if (currentPageComposition!.canFit(pageComponent:item)) {
            currentPageComposition!.withItemTableRowComponent(item)
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            self.initNewPageWithMinimumComposition(copyTemplate)
            currentPageComposition!.withItemTableRowComponent(ItemTableHeaderComponent(headerData: self.creditNote.itemColumnNames))
            currentPageComposition!.withItemTableRowComponent(item)
        }
    }
    
    fileprivate func appendIfFitsOtherwiseCreateNewPageCompositionItemBefore(item: PageComponent) {
        if (currentPageComposition!.canFit(pageComponent:item)) {
            currentPageComposition!.withItemBeforeTableRowComponent(item)
        } else {
            self.pagesWithTableData.append(currentPageComposition!)
            self.initNewPageWithMinimumComposition(copyTemplate)
            currentPageComposition!.withItemBeforeTableRowComponent(ItemTableHeaderComponent(headerData: self.creditNote.itemColumnNames))
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
                .forEach({page in pagesWithTableData[page].withPageNumberingComponent(PageNumberingComponent(page: page + 1, of: pagesWithTableData.count, isI10n: self.creditNote.isInternational()))})
        }
    }
    
    func addMandayFakturaCredit() {
        (0 ..< pagesWithTableData.count)
            .forEach({page in pagesWithTableData[page].withMandayFakturaCreditComponent(MandayFakturaCreditComponent(isI10n: self.creditNote.isInternational(), primaryLanguage: self.creditNote.primaryLanguage))})
    }
}
