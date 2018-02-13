//
//  CounterpartyRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 08.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

/**
 * The protocol for counterparty repository
 */
protocol CounterpartyRepository {
   /**
    Returns the seller
    */
    func getSeller() -> Counterparty?
    
    /*
    Saves seller
     */
    func saveSeller(seller: Counterparty)
}
