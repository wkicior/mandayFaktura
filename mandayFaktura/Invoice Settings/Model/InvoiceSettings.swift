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
    var paymentDateFrom = PaymentDateFrom.today
    
    init(paymentDateDays: Int, paymentDateFrom: PaymentDateFrom = PaymentDateFrom.today) {
        self.paymentDateDays = paymentDateDays
        self.paymentDateFrom = paymentDateFrom
    }
}
