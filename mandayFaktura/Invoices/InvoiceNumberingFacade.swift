//
//  InvoiceNumberingFacade.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 22.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InvoiceNumberingFacade {
    let invoiceNumberingSettingsRepository: InvoiceNumberingSettingsRepository = InvoiceNumberingSettingsRepositoryFactory.instance
    
    func getInvoiceNumberingSettings() -> InvoiceNumberingSettings? {
        return invoiceNumberingSettingsRepository.getInvoiceNumberingSettings()
    }
    
    func save(invoiceNumberingSettings: InvoiceNumberingSettings) {
        self.invoiceNumberingSettingsRepository.save(invoiceNumberingSettings: invoiceNumberingSettings)
    }
    
    func getNextInvoiceNumber() -> String {
        let invoiceNumbering: InvoiceNumbering = InvoiceNumbering()
        return invoiceNumbering.nextInvoiceNumber
    }
}
