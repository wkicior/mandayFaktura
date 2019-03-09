//
//  CreditNoteNumberingFacade.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 02.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class CreditNoteNumberingFacade {
    let creditNoteNumberingSettingsRepository: CreditNoteNumberingSettingsRepository = CreditNoteNumberingSettingsRepositoryFactory.instance

    
    func getCreditNoteNumberingSettings() -> CreditNoteNumberingSettings? {
        return self.creditNoteNumberingSettingsRepository.getCreditNoteNumberingSettings()
    }
    
    func save(creditNoteNumberingSettings: CreditNoteNumberingSettings) {
        self.creditNoteNumberingSettingsRepository.save(creditNoteNumberingSettings: creditNoteNumberingSettings)
    }
    
    func getNextCreditNoteNumber() -> String {
        let creditNoteNumbering: CreditNoteNumbering = CreditNoteNumbering()
        return creditNoteNumbering.nextCreditNoteNumber
    }
}
