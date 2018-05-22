//
//  InvoiceNumberingInteractor.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 22.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InvoiceNumberingInteractor {
    let invoiceNumberingSettingsRepository: InvoiceNumberingSettingsRepository = InvoiceNumberingSettingsRepositoryFactory.instance
    let invoiceRepository: InvoiceRepository = InvoiceRepositoryFactory.instance
    
    func getInvoiceNumberingSettings() -> InvoiceNumberingSettings? {
        return invoiceNumberingSettingsRepository.getInvoiceNumberingSettings()
    }
    
    func save(invoiceNumberingSettings: InvoiceNumberingSettings) {
        self.invoiceNumberingSettingsRepository.save(invoiceNumberingSettings: invoiceNumberingSettings)
    }
    
    func getNextInvoiceNumber() -> String {
        let invoiceNumbering: InvoiceNumbering = InvoiceNumbering(invoiceRepository: invoiceRepository, invoiceNumberingSettingsRepository: invoiceNumberingSettingsRepository)
        return invoiceNumbering.nextInvoiceNumber
    }
}
