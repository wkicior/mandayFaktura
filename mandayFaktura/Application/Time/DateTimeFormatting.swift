//
//  DateTimeFormatter.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 06/01/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation


public extension Date {
    
    static let dateDotFormatter: DateFormatter = {
        let result =  DateFormatter()
        result.timeStyle = .none
        result.dateStyle = .short
        return result
    }()
    
    static let dateBigEndianDashFormatter: DateFormatter = {
        let result =  DateFormatter()
        result.dateFormat = "yyyy-MM-dd"
        return result
    }()
    
    static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone, .withFractionalSeconds]
        formatter.timeZone = TimeZone.current
        return formatter
    }()


    func toIsoString() -> String {
        return Date.isoFormatter.string(from: self)
    }
    
    func toDateDotString() -> String {
        return Date.dateDotFormatter.string(from: self)
    }
    
    func toDateBigEndianDashString() -> String {
        return Date.dateBigEndianDashFormatter.string(from: self)
    }
}
