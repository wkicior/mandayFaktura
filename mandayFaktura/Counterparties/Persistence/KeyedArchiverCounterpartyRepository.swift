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
    func replaceBuyer(_ buyer: Counterparty, with: Counterparty) {
        let newBuyer = CounterpartyCoding(with)
        let index = buyersCoding.index(where: {c in c.counterparty.name == buyer.name && c.counterparty.taxCode == buyer.taxCode})
        buyersCoding[index!] = newBuyer
    }
    
    private let sellerKey = "seller" + AppDelegate.keyedArchiverProfile
    private let buyersKey = "buyers" + AppDelegate.keyedArchiverProfile
    func saveSeller(seller: Counterparty) {
        sellerCoding = CounterpartyCoding(seller)
    }
    
    func getSeller() -> Counterparty? {
        return sellerCoding?.counterparty
    }
    
    func getBuyers() -> [Counterparty] {
        return buyersCoding.map{buyer in buyer.counterparty}
    }
    
    func getBuyer(name: String) -> Counterparty? {
        return getBuyers().first(where: {bc in bc.name == name})
    }
    
    func addBuyer(buyer: Counterparty) {
        buyersCoding.append(CounterpartyCoding(buyer))
    }
    
    func update(buyer: Counterparty) {
        let index = buyersCoding.index(where: {bc in bc.counterparty.name == buyer.name})
        buyersCoding[index!] = CounterpartyCoding(buyer)
    }
    
    func saveBuyers(_ buyers: [Counterparty]) {
        buyersCoding = buyers.map{b in CounterpartyCoding(b)}
    }
    
    private var sellerCoding: CounterpartyCoding? {
        get {
            if let data = UserDefaults.standard.object(forKey: sellerKey) as? NSData {
                return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? CounterpartyCoding
            }
            return nil
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue!)
            UserDefaults.standard.set(data, forKey: sellerKey)
        }
    }
    
    private var buyersCoding: [CounterpartyCoding] {
        get {
            if let data = UserDefaults.standard.object(forKey: buyersKey) as? NSData {
                return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [CounterpartyCoding]
            }
            return []
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: buyersKey)
        }
    }
}


