//
//  DocumentPageDistribution.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 24.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol DocumentPageDistribution {
    func distributeDocumentOverPageCompositions() -> [InvoicePageComposition]
}
