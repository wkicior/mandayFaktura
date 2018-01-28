//
//  InvoiceRepository.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 28.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol InvoiceRepository {
    func getInvoices() -> [Invoice]
}
