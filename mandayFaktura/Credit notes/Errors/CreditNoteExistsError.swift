//
//  CreditNoteExistsError.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 23.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

enum CreditNoteExistsError: Error {
    case creditNoteNumber(number: String)
}
