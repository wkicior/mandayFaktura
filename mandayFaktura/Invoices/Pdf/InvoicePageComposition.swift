//
//  InvoicePageComposition.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

struct InvoicePageComposition {
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
}

func anInvoicePageComposition() -> InvoicePageCompositionBuilder {
    return InvoicePageCompositionBuilder()
}

class InvoicePageCompositionBuilder {
    private var header: HeaderLayout?
    private var dates: HeaderInvoiceDatesLayout?
    private var copyLabel: CopyLabelLayout?
    private var seller: SellerLayout?
    private var buyer: BuyerLayout?
    private var itemTableData: ItemTableLayout?
    private var itemsSummary: ItemsSummaryLayout?
    private var vatBreakdownTableData: VatBreakdownLayout?
    private var paymentSummary: PaymentSummaryLayout?
    private var notes: NotesLayout?
    
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
            itemsSummary: itemsSummary ?? ItemsSummaryLayout(summaryData: []),
            vatBreakdownTableData: vatBreakdownTableData ?? VatBreakdownLayout(breakdownLabel: "", breakdownTableData: []),
            paymentSummary: paymentSummary ?? PaymentSummaryLayout(content: ""),
            notes: notes ?? NotesLayout(content: ""))
    }
}
