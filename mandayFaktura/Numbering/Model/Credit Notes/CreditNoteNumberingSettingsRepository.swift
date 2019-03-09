//
//  CreditNoteNumberingSettingsRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 09.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol CreditNoteNumberingSettingsRepository {
    func getCreditNoteNumberingSettings() -> CreditNoteNumberingSettings?
    
    func save(creditNoteNumberingSettings: CreditNoteNumberingSettings)
}
