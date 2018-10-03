//
//  InvoiceSettingsInteractor.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.09.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
class InvoiceSettingsInteractor {
    let invoiceSettingsRepository: InvoiceSettingsRepository = InvoiceSettingsRepositoryFactory.instance
    
    func getInvoiceSettings() -> InvoiceSettings? {
        return invoiceSettingsRepository.getInvoiceSettings()
    }
    
    func save(_ invoiceSettings: InvoiceSettings) {
        self.invoiceSettingsRepository.saveInvoiceSettings(invoiceSettings)
    }
}
