//
//  KeyedArchiverCounterpartyRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 13.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

@objc(CounterpartyCoding) class CounterpartyCoding: NSObject, NSCoding {
    let counterparty: Counterparty
    
    func encode(with coder: NSCoder) {
        coder.encode(self.counterparty.name, forKey: "name")
        coder.encode(self.counterparty.streetAndNumber, forKey: "streetAndNumber")
        coder.encode(self.counterparty.city, forKey: "city")
        coder.encode(self.counterparty.postalCode, forKey: "postalCode")
        coder.encode(self.counterparty.taxCode, forKey: "taxCode")
        coder.encode(self.counterparty.accountNumber, forKey: "accountNumber")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: "name") as? String,
            let streetAndNumber = decoder.decodeObject(forKey: "streetAndNumber") as? String,
            let city = decoder.decodeObject(forKey: "city") as? String,
            let postalCode = decoder.decodeObject(forKey: "postalCode") as? String,
            let taxCode = decoder.decodeObject(forKey: "taxCode") as? String,
            let accountNumber = decoder.decodeObject(forKey: "accountNumber") as? String
        else { return nil }
        
        self.init(Counterparty(name: name, streetAndNumber: streetAndNumber, city: city, postalCode: postalCode, taxCode: taxCode, accountNumber: accountNumber))
    }
    
    init(_ counterparty: Counterparty) {
        self.counterparty = counterparty
    }
    
}

/**
The implementation of CounterpartyRepository using NSKeyedArchiver storage
 */
class KeyedArchiverCounterpartyRepository: CounterpartyRepository {
    private let key = "seller"
    func saveSeller(seller: Counterparty) {
        let data = NSKeyedArchiver.archivedData(withRootObject: CounterpartyCoding(seller))
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func getSeller() -> Counterparty? {
        if let data = UserDefaults.standard.object(forKey: key) as? NSData {
            let seller:CounterpartyCoding = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! CounterpartyCoding
            return seller.counterparty
        }
        return nil
    }
}


