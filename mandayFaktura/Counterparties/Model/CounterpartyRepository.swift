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
    
    /**
    Gets all the buyers
     */
    func getBuyers() -> [Counterparty]
    
    func addBuyer(buyer: Counterparty)
    
    func update(buyer: Counterparty)
}

/**
 This class will provide the instances of implementations of CounterpartyRepository
 */
class CounterpartyRepositoryFactory {
    private static var repository: CounterpartyRepository?
    
    /**
    Applicaiton registers the instance to be used as a CounterpartyRepository through this method
     */
    static func register(repository: CounterpartyRepository) {
        CounterpartyRepositoryFactory.repository = repository
    }
    static var instance: CounterpartyRepository {
        get {
            return repository!
        }
    }
}
