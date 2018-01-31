//
//  Invoice.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 27.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct Invoice {
    let issueDate: Date
    let number: String
    let sellingDate: Date
    let seller: Counterparty
    let buyer: Counterparty
}
