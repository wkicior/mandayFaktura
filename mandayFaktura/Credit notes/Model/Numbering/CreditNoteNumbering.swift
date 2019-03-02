//
//  CreditNoteNumbering.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 02.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class CreditNoteNumbering {
    private let creditNoteRepository: CreditNoteRepository
    
    init(creditNoteRepository: CreditNoteRepository = CreditNoteRepositoryFactory.instance) {
        self.creditNoteRepository = creditNoteRepository
    }
    
    func verifyCreditNoteWithNumberDoesNotExist(creditNoteNumber: String) throws {
        if (creditNoteRepository.findBy(creditNoteNumber: creditNoteNumber) != nil) {
            throw CreditNoteExistsError.creditNoteNumber(number: creditNoteNumber)
        }
    }
}
