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
    
    let header: HeaderComponent
    let dates: HeaderInvoiceDatesComponent
    let copyLabel: CopyLabelComponent
    let seller: SellerComponent
    let buyer: BuyerComponent
    let itemTableHeaderComponent: ItemTableHeaderComponent
    let itemTableData: ItemTableComponent
    let itemsSummary: ItemsSummaryComponent
    let vatBreakdownTableData: VatBreakdownComponent
    let paymentSummary: PaymentSummaryComponent
    let notes: NotesComponent
    
    func draw() {
        //TODO: extract prototype and iterate over array
        self.header.draw()
        self.dates.draw()
        self.copyLabel.draw()
        self.seller.draw()
        self.buyer.draw()
        self.itemTableHeaderComponent.draw()
        self.itemTableData.draw()
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
    var header: HeaderComponent?
    var dates: HeaderInvoiceDatesComponent?
    var copyLabel: CopyLabelComponent?
    var seller: SellerComponent?
    var buyer: BuyerComponent?
    var itemTableHeaderComponent: ItemTableHeaderComponent?
    var itemTableData: ItemTableComponent?
    var itemsSummary: ItemsSummaryComponent?
    var vatBreakdownTableData: VatBreakdownComponent?
    var paymentSummary: PaymentSummaryComponent?
    var notes: NotesComponent?
    
    func withHeader(_ header: HeaderComponent) -> InvoicePageCompositionBuilder {
        self.header = header
        return self
    }
    
    func withDates(_ dates: HeaderInvoiceDatesComponent) -> InvoicePageCompositionBuilder {
        self.dates = dates
        return self
    }
    
    func withCopyLabel(_ copyLabel: CopyLabelComponent) -> InvoicePageCompositionBuilder {
        self.copyLabel = copyLabel
        return self
    }
    
    func withSeller(_ seller: SellerComponent) -> InvoicePageCompositionBuilder {
        self.seller = seller
        return self
    }
    
    func withBuyer(_ buyer: BuyerComponent) -> InvoicePageCompositionBuilder {
        self.buyer = buyer
        return self
    }
    
    func withItemTableData(_ itemTableData: ItemTableComponent) -> InvoicePageCompositionBuilder {
        self.itemTableData = itemTableData
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
            header: header ?? HeaderComponent(content: ""),
            dates: dates ?? HeaderInvoiceDatesComponent(content: ""),
            copyLabel: copyLabel ?? CopyLabelComponent(content: ""),
            seller: seller ?? SellerComponent(content: ""),
            buyer: buyer ?? BuyerComponent(content: ""),
            itemTableHeaderComponent: itemTableHeaderComponent ?? ItemTableHeaderComponent(headerData: []),
            itemTableData: itemTableData ?? ItemTableComponent(tableData: []),
            itemsSummary: itemsSummary ?? ItemsSummaryComponent(summaryData: [], yTopPosition: CGFloat(0)),
            vatBreakdownTableData: vatBreakdownTableData ?? VatBreakdownComponent(breakdownLabel: "", breakdownTableData: [], topYPosition: CGFloat(0)),
            paymentSummary: paymentSummary ?? PaymentSummaryComponent(content: "", topYPosition: CGFloat(0)),
            notes: notes ?? NotesComponent(content: "", topYPosition: CGFloat(0)))
    }
}
