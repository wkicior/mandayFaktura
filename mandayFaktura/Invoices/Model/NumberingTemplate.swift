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

class IncrementWithYearNumberingTemplate: NumberingTemplate {
    let pattern = "\\b(\\d+)/[\\d\\w]+/\\d{4}\\b"
    func getInvoiceNumber(incrementingNumber: Int) -> String {
        return "\(incrementingNumber)/A/\(Date().year)"
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
