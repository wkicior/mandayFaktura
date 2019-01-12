//
//  InvoiceSettings.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.09.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InvoiceSettings {
    var paymentDateDays = 0
    var paymentDateFrom = PaymentDateFrom.createDate
    var defaultNotes = ""
    
    init(paymentDateDays: Int, paymentDateFrom: PaymentDateFrom = PaymentDateFrom.createDate, defaultNotes: String = "") {
        self.paymentDateDays = paymentDateDays
        self.paymentDateFrom = paymentDateFrom
        self.defaultNotes = defaultNotes
    }
    
    func getDueDate(issueDate: Date, sellDate: Date) -> Date {
        return getDueDate(date: selectDateFrom(issueDate: issueDate, sellDate: sellDate))
    }
    
    private func selectDateFrom(issueDate: Date, sellDate: Date) -> Date {
        switch(paymentDateFrom) {
        case .createDate:
            return Date()
        case .issueDate:
            return issueDate
        case .sellDate:
            return sellDate
        }
    }
    
    func getDueDate(date: Date) -> Date {
         return Calendar.current.date(byAdding: .day, value: paymentDateDays, to: date)!
    }
}
