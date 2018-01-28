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
}
