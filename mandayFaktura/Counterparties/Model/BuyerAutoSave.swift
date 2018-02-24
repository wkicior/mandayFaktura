//
//  BuyerAutoSave.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 20.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class BuyerAutoSave {
    var counterpartyRepository = CounterpartyRepositoryFactory.instance
    
    init() {
        //
    }
    
    // for testing purposes only
    init(_ counterpartyRepository: CounterpartyRepository) {
        self.counterpartyRepository = counterpartyRepository
    }
    
    func saveIfNew(buyer: Counterparty) throws {
        let buyerFromRepo = counterpartyRepository.getBuyers().first(where: {b in buyer.name == b.name})
        if (buyerFromRepo != nil && buyerFromRepo! != buyer) {
            throw AnotherBuyerWithThatNameExistsError()
        } else if (buyerFromRepo == nil) {
            counterpartyRepository.addBuyer(buyer: buyer)
        }
    }
    
    func update(buyer: Counterparty) {
        counterpartyRepository.update(buyer: buyer)
    }
}
