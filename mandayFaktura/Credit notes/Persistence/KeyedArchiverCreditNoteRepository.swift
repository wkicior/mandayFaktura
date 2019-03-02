//
//  KeyedArchiverCreditNoteRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 23.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class KeyedArchiverCreditNoteRepository: CreditNoteRepository {
    private let key = "creditNotes" + AppDelegate.keyedArchiverProfile
    
    func getCreditNotes() -> [CreditNote] {
        return creditNotesCoding.map{cnc in cnc.creditNote}
    }
    
    func addCreditNote(_ creditNote: CreditNote) {
        creditNotesCoding.append(CreditNoteCoding(creditNote))
    }
    
    func findBy(creditNoteNumber: String) -> CreditNote? {
        return getCreditNotes().first(where: {i in i.number == creditNoteNumber})
    }
    
    func deleteCreditNote(_ creditNote: CreditNote) {
        let index = creditNotesCoding.index(where: {ic in ic.creditNote.number == creditNote.number})
        creditNotesCoding.remove(at: index!)
    }
    
    func findBy(invoiceNumber: String) -> CreditNote? {
        return getCreditNotes().first(where: {c in c.invoiceNumber == invoiceNumber})
    }
    
    func getLastCreditNote() -> CreditNote? {
        return creditNotesCoding.last.map({ic in ic.creditNote})
    }

    private var creditNotesCoding: [CreditNoteCoding] {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? NSData {
                return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [CreditNoteCoding]
            }
            return []
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
