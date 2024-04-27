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
        coder.encode(self.invoiceSettings.mandayFakturaCreditEnabled, forKey: "mandayFakturaCreditEnabled")
        coder.encode(self.invoiceSettings.primaryDefaultLanguage.rawValue, forKey: "primaryDefaultLanguage")
        coder.encode(self.invoiceSettings.secondaryDefaultLanguage?.rawValue ?? nil, forKey: "secondaryDefaultLanguage")
        coder.encode(self.invoiceSettings.defaultCurrency.rawValue, forKey: "defaultCurrency")

    }
    
    required convenience init?(coder decoder: NSCoder) {
        let paymentDateDays = decoder.decodeInteger(forKey: "paymentDateDays")
        let paymentDateFrom = PaymentDateFrom(rawValue: (decoder.decodeInteger(forKey: "paymentDateFrom")))!
        let defaultNotes = decoder.decodeObject(forKey: "defaultNotes") as? String
        let mandayFakturaCreditEnabled = decoder.decodeBool(forKey: "mandayFakturaCreditEnabled")
        var primaryLanguageCode = decoder.decodeObject(forKey: "primaryDefaultLanguage") as? String
        var secondaryLanguageCode = decoder.decodeObject(forKey: "secondaryDefaultLanguage") as? String
        let defaultCurrencyCode = decoder.decodeObject(forKey: "defaultCurrency") as? String

        let defaultCurrency = defaultCurrencyCode.flatMap() { Currency(rawValue: $0) } ?? Currency.PLN

        
        if (primaryLanguageCode == nil) {
            primaryLanguageCode = Language.PL.rawValue
        }
        
        self.init(InvoiceSettings(paymentDateDays: paymentDateDays, paymentDateFrom: paymentDateFrom,
                                  defaultNotes: defaultNotes ?? "",
                                  mandayFakturaCreditEnabled: mandayFakturaCreditEnabled,
                                  primaryDefaultLanguage: Language(rawValue: primaryLanguageCode!)!,
                                  secondaryDefaultLanguage: secondaryLanguageCode.map({Language(rawValue: $0)!}) ?? nil,
                                  defaultCurrency: defaultCurrency))
    }
    
    init(_ invoiceSettings: InvoiceSettings) {
        self.invoiceSettings = invoiceSettings
    }
}
