//
//  InvoiceExistsError.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 26.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

enum InvoiceExistsError: Error {
    case invoiceNumber(number: String)
}
