//
//  NumberingTemplate.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 14.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol NumberingTemplate {
    func getIncrementingNumber(invoiceNumber: String) -> Int?
    
    func getInvoiceNumber(incrementingNumber: Int) -> String
}

private extension Date {
    var year: Int {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: Date())
            return Int(year)!
        }
    }
}

enum TemplateOrdering: String {
    case year = "\\d{4}", fixedPart = "[\\d\\w]+", incrementingNumber = "(\\d+)"
}

class IncrementWithYearNumberingTemplate: NumberingTemplate {
    let pattern: String
    let fixedPart: String
    let ordering: [TemplateOrdering]
    let separator: String
    init(delimeter: String, fixedPart: String, ordering: [TemplateOrdering]) {
        self.separator = delimeter
        self.fixedPart = fixedPart //fixedPart is not applied to the pattern so the customer may change it without breaking the pattern
        self.ordering = ordering
        pattern = "\\b\(ordering[0].rawValue)\(delimeter)\(ordering[1].rawValue)\(delimeter)\(ordering[2].rawValue)\\b"
    }
    func getInvoiceNumber(incrementingNumber: Int) -> String {
        let orderingValues: [TemplateOrdering: String] = [.year: "\(Date().year)", .incrementingNumber: String(incrementingNumber), .fixedPart: fixedPart]
        return self.ordering.map({oi in orderingValues[oi]!}).joined(separator: self.separator)
    }
    
    func getIncrementingNumber(invoiceNumber: String) -> Int? {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: invoiceNumber, options: [], range: NSRange(location: 0, length: invoiceNumber.count))
        if let match = matches.first {
            let range = match.range(at:1)
            if let swiftRange = Range(range, in: invoiceNumber) {
                return Int(invoiceNumber[swiftRange])
            }
        }
        return nil
      
        
    }
}
