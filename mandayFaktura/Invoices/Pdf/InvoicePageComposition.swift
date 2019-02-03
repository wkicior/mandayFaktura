//
//  InvoicePageComposition.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

struct InvoicePageComposition {
    let header: String
    let dates: String
    let copyLabel: String
    let seller: String
    let buyer: String
    let itemTableData: [[String]]
    let itemsSummary: [String]
    let vatBreakdownTableData: [[String]]
    let paymentSummary: String
    let notes: String
}


func anInvoicePageComposition() -> InvoicePageCompositionBuilder {
    return InvoicePageCompositionBuilder()
}

class InvoicePageCompositionBuilder {
    private var header: String = ""
    private var dates: String = ""
    private var copyLabel: String = ""
    private var seller: String = ""
    private var buyer: String = ""
    private var itemTableData: [[String]] = []
    private var itemsSummary: [String] = []
    private var vatBreakdownTableData: [[String]] = []
    private var paymentSummary: String = ""
    private var notes: String = ""
    
    func withHeader(_ header: String) -> InvoicePageCompositionBuilder {
        self.header = header
        return self
    }
    
    func withDates(_ dates: String) -> InvoicePageCompositionBuilder {
        self.dates = dates
        return self
    }
    
    func withCopyLabel(_ copyLabel: String) -> InvoicePageCompositionBuilder {
        self.copyLabel = copyLabel
        return self
    }
    
    func withSeller(_ seller: String) -> InvoicePageCompositionBuilder {
        self.seller = seller
        return self
    }
    
    func withBuyer(_ buyer: String) -> InvoicePageCompositionBuilder {
        self.buyer = buyer
        return self
    }
    
    func withItemTableData(_ itemTableData: [[String]]) -> InvoicePageCompositionBuilder {
        self.itemTableData = itemTableData
        return self
    }
    
    func withItemsSummary(_ itemsSummary: [String]) -> InvoicePageCompositionBuilder {
        self.itemsSummary = itemsSummary
        return self
    }
    
    func withVatBreakdownTableData(_ vatBreakdownTableData: [[String]]) -> InvoicePageCompositionBuilder {
        self.vatBreakdownTableData = vatBreakdownTableData
        return self
    }
    
    func withPaymentSummary(_ paymentSummary: String) -> InvoicePageCompositionBuilder {
        self.paymentSummary = paymentSummary
        return self
    }
    
    func withNotes(_ notes: String) -> InvoicePageCompositionBuilder {
        self.notes = notes
        return self
    }
    
    func build() -> InvoicePageComposition {
        return InvoicePageComposition(
            header: header,
            dates: dates,
            copyLabel: copyLabel,
            seller: seller,
            buyer: buyer,
            itemTableData: itemTableData,
            itemsSummary: itemsSummary,
            vatBreakdownTableData: vatBreakdownTableData,
            paymentSummary: paymentSummary,
            notes: notes)
    }
}
