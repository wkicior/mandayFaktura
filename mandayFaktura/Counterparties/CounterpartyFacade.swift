//
//  CounterpartyFacade.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 21.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class CounterpartyFacade {
    let counterpartyRepository = CounterpartyRepositoryFactory.instance
    
    func saveSeller(seller: Counterparty) {
        counterpartyRepository.saveSeller(seller: seller)
    }
    
    func getSeller() -> Counterparty? {
        return counterpartyRepository.getSeller()
    }
    
    func saveBuyers(_ buyers: [Counterparty]) {
        counterpartyRepository.saveBuyers(buyers)
    }
    
    func getBuyers() -> [Counterparty] {
        return counterpartyRepository.getBuyers()
    }
    
    func replaceBuyer(_ buyer: Counterparty, with: Counterparty) {
        return counterpartyRepository.replaceBuyer(buyer, with: with)
    }
    
    func addBuyer(buyer: Counterparty) {
        counterpartyRepository.addBuyer(buyer: buyer)
    }
    
    func getBuyer(name: String) -> Counterparty? {
        return counterpartyRepository.getBuyer(name: name)
    }

}
