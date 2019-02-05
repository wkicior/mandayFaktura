//
//  DateFormatting.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

class DateFormatting {
    let dateFormatter = DateFormatter()
    init() {
        self.dateFormatter.timeStyle = .none
        self.dateFormatter.dateStyle = .short
    }
    
    func getDateString(_ date: Date) -> String {
        return self.dateFormatter.string(from: date)
    }
    
    static func getDateString(_ date: Date) -> String {
        return DateFormatting().getDateString(date)
    }
}
