//
//  InvoiceNumberingSettingsRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 16.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol InvoiceNumberingSettingsRepository {
    func getInvoiceNumberingSettings() -> InvoiceNumberingSettings?
    
    func save(invoiceNumberingSettings: InvoiceNumberingSettings)
}
