//
//  CreditNoteNumberingFacade.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 02.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class CreditNoteNumberingFacade {
    
    func getNextCreditNoteNumber() -> String {
        let creditNoteNumbering: CreditNoteNumbering = CreditNoteNumbering()
        return creditNoteNumbering.nextCreditNoteNumber
    }
}
