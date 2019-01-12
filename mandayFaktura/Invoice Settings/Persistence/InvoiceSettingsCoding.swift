//
//  InvoiceSettingsCoding.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 29.09.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

@objc(InvoiceSettingsCoding) class InvoiceSettingsCoding: NSObject, NSCoding {
    let invoiceSettings: InvoiceSettings
    
    func encode(with coder: NSCoder) {
        coder.encode(self.invoiceSettings.paymentDateDays, forKey: "paymentDateDays")
        coder.encode(self.invoiceSettings.paymentDateFrom.rawValue, forKey: "paymentDateFrom")
        coder.encode(self.invoiceSettings.defaultNotes, forKey: "defaultNotes")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let paymentDateDays = decoder.decodeInteger(forKey: "paymentDateDays")
        let paymentDateFrom = PaymentDateFrom(rawValue: (decoder.decodeInteger(forKey: "paymentDateFrom")))!
        let defaultNotes = decoder.decodeObject(forKey: "defaultNotes") as? String
        self.init(InvoiceSettings(paymentDateDays: paymentDateDays, paymentDateFrom: paymentDateFrom, defaultNotes: defaultNotes ?? ""))
    }
    
    init(_ invoiceSettings: InvoiceSettings) {
        self.invoiceSettings = invoiceSettings
    }
}
