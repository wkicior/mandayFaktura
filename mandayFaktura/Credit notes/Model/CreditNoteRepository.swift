//
//  CreditNoteRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 23.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol CreditNoteRepository {
    func getCreditNotes() -> [CreditNote]
    
    /**
     Adds new credit note to the repository
     */
    func addCreditNote(_ creditNote: CreditNote)
    
    func deleteCreditNote(_ creditNote: CreditNote)
    
    func findBy(invoiceNumber: String) -> CreditNote?
    
    func findBy(creditNoteNumber: String) -> CreditNote?
    
    /**
     Returns last registered credit note
     */
    func getLastCreditNote() -> CreditNote?
}


/**
 This class will provide the instances of implementations of CreditNoteRepository
 */
class CreditNoteRepositoryFactory {
    private static var repository: CreditNoteRepository?
    
    /**
     Applicaiton registers the instance to be used as a InvoiceRepository through this method
     */
    static func register(repository: CreditNoteRepository) {
        CreditNoteRepositoryFactory.repository = repository
    }
    static var instance: CreditNoteRepository {
        get {
            return repository!
        }
    }
}
