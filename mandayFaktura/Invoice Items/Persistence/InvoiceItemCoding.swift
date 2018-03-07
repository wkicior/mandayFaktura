//
//  InvoiceItemCoding.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 17.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

@objc(InvoiceItemCoding) class InvoiceItemCoding: NSObject, NSCoding {
    let invoiceItem: InvoiceItem
    
    func encode(with coder: NSCoder) {
        coder.encode(self.invoiceItem.name, forKey: "name")
        coder.encode(self.invoiceItem.amount, forKey: "amount")
        coder.encode(self.invoiceItem.unitNetPrice, forKey: "unitNetPrice")
        coder.encode(self.invoiceItem.unitOfMeasure.rawValue, forKey: "unitOfMeasure")
        coder.encode(self.invoiceItem.vatRateInPercent, forKey: "vatRateInPercent")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: "name") as? String,
            let amount = decoder.decodeObject(forKey: "amount") as? Decimal,
            let unitNetPrice = decoder.decodeObject(forKey: "unitNetPrice") as? Decimal,
            let vatRateInPercent = decoder.decodeObject(forKey: "vatRateInPercent") as? Decimal
            else { return nil }
        let unitOfMeasure = UnitOfMeasure(rawValue: (decoder.decodeInteger(forKey: "unitOfMeasure")))!
        self.init(anInvoiceItem()
            .withName(name)
            .withAmount(amount)
            .withUnitNetPrice(unitNetPrice)
            .withUnitOfMeasure(unitOfMeasure)
            .withVatRateInPercent(vatRateInPercent)
            .build())
    }
    
    init(_ invoiceItem: InvoiceItem) {
        self.invoiceItem = invoiceItem
    }
}
