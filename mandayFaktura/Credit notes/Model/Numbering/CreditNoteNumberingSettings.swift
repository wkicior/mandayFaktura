//
//  CreditNoteNumberingSettings.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 02.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

struct CreditNoteNumberingSettings: DocumentNumberingSettings {
    let separator: String
    let segments: [NumberingSegment]
    let resetOnYearChange: Bool
}
