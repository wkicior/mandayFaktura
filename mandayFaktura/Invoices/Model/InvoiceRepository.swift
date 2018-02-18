//
//  InvoiceRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 28.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

/**
 * The protocol for the invoices repository.
 * Extracting the protocol follows the IoC principle allowing to plug-in any persistance implementation without polluting the model
 */
protocol InvoiceRepository {
    /**
     Returns all the invoices
     */
    func getInvoices() -> [Invoice]
    
    /**
    Adds new invoice to the repository
    */
    func addInvoice(_ invoice:Invoice)
}

/**
 This class will provide the instances of implementations of CounterpartyRepository
 */
class InvoiceRepositoryFactory {
    private static var repository: InvoiceRepository?
    
    /**
     Applicaiton registers the instance to be used as a InvoiceRepository through this method
     */
    static func register(repository: InvoiceRepository) {
        InvoiceRepositoryFactory.repository = repository
    }
    static var instance: InvoiceRepository {
        get {
            return repository!
        }
    }
}
