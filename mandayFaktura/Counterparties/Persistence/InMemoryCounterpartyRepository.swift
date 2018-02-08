//
//  InMemoryCounterpartyRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 08.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class InMemoryCounterpartyRepository: CounterpartyRepository {
    func getSeller() -> Counterparty {
        return Counterparty(name: "Wojciech Kicior", streetAndNumber: "Github.com 1/100", city: "Internet", postalCode: "13-37", taxCode: "666-555-44-33", accountNumber: "69 0000 0000 1234 8877")
    }
}
