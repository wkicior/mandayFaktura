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
    
    let header: HeaderLayout
    let dates: HeaderInvoiceDatesLayout
    let copyLabel: CopyLabelLayout
    let seller: SellerLayout
    let buyer: BuyerLayout
    let itemTableData: ItemTableLayout
    let itemsSummary: ItemsSummaryLayout
    let vatBreakdownTableData: VatBreakdownLayout
    let paymentSummary: PaymentSummaryLayout
    let notes: NotesLayout
    
    func draw() {
        //TODO: extract prototype and iterate over array
        self.header.draw()
        self.dates.draw()
        self.copyLabel.draw()
        self.seller.draw()
        self.buyer.draw()
        self.itemTableData.draw()
        self.itemsSummary.draw()
        self.vatBreakdownTableData.draw()
        self.paymentSummary.draw()
        self.notes.draw()
    }
}

func anInvoicePageComposition() -> InvoicePageCompositionBuilder {
    return InvoicePageCompositionBuilder()
}

class InvoicePageCompositionBuilder {
    var header: HeaderLayout?
    var dates: HeaderInvoiceDatesLayout?
    var copyLabel: CopyLabelLayout?
    var seller: SellerLayout?
    var buyer: BuyerLayout?
    var itemTableData: ItemTableLayout?
    var itemsSummary: ItemsSummaryLayout?
    var vatBreakdownTableData: VatBreakdownLayout?
    var paymentSummary: PaymentSummaryLayout?
    var notes: NotesLayout?
    
    func withHeader(_ header: HeaderLayout) -> InvoicePageCompositionBuilder {
        self.header = header
        return self
    }
    
    func withDates(_ dates: HeaderInvoiceDatesLayout) -> InvoicePageCompositionBuilder {
        self.dates = dates
        return self
    }
    
    func withCopyLabel(_ copyLabel: CopyLabelLayout) -> InvoicePageCompositionBuilder {
        self.copyLabel = copyLabel
        return self
    }
    
    func withSeller(_ seller: SellerLayout) -> InvoicePageCompositionBuilder {
        self.seller = seller
        return self
    }
    
    func withBuyer(_ buyer: BuyerLayout) -> InvoicePageCompositionBuilder {
        self.buyer = buyer
        return self
    }
    
    func withItemTableData(_ itemTableData: ItemTableLayout) -> InvoicePageCompositionBuilder {
        self.itemTableData = itemTableData
        return self
    }
    
    func withItemsSummary(_ itemsSummary: ItemsSummaryLayout) -> InvoicePageCompositionBuilder {
        self.itemsSummary = itemsSummary
        return self
    }
    
    func withVatBreakdownTableData(_ vatBreakdownTableData: VatBreakdownLayout) -> InvoicePageCompositionBuilder {
        self.vatBreakdownTableData = vatBreakdownTableData
        return self
    }
    
    func withPaymentSummary(_ paymentSummary: PaymentSummaryLayout) -> InvoicePageCompositionBuilder {
        self.paymentSummary = paymentSummary
        return self
    }
    
    func withNotes(_ notes: NotesLayout) -> InvoicePageCompositionBuilder {
        self.notes = notes
        return self
    }
    
    func build() -> InvoicePageComposition {
        return InvoicePageComposition(
            header: header ?? HeaderLayout(content: ""),
            dates: dates ?? HeaderInvoiceDatesLayout(content: ""),
            copyLabel: copyLabel ?? CopyLabelLayout(content: ""),
            seller: seller ?? SellerLayout(content: ""),
            buyer: buyer ?? BuyerLayout(content: ""),
            itemTableData: itemTableData ?? ItemTableLayout(headerData: [], tableData: []),
            itemsSummary: itemsSummary ?? ItemsSummaryLayout(summaryData: [], yTopPosition: CGFloat(0)),
            vatBreakdownTableData: vatBreakdownTableData ?? VatBreakdownLayout(breakdownLabel: "", breakdownTableData: [], topYPosition: CGFloat(0)),
            paymentSummary: paymentSummary ?? PaymentSummaryLayout(content: "", topYPosition: CGFloat(0)),
            notes: notes ?? NotesLayout(content: "", topYPosition: CGFloat(0)))
    }
}
