//
//  TemplateOrdering.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 16.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation


enum TemplateOrdering: String {
    case year = "\\d{4}", fixedPart = "[\\d\\w]+", incrementingNumber = "(\\d+)"
}
