//
//  Counterparty.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 31.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

struct Counterparty {
    let name:String
    let streetAndNumber: String
    let city: String
    let postalCode: String
    let taxCode: String
    let accountNumber: String
    let additionalInfo: String
    let country: String
}

extension Counterparty: Equatable {
    static func == (lhs: Counterparty, rhs: Counterparty) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.streetAndNumber == rhs.streetAndNumber &&
            lhs.city == rhs.city &&
            lhs.postalCode == rhs.postalCode &&
            lhs.taxCode == rhs.taxCode &&
            lhs.accountNumber == rhs.accountNumber &&
            lhs.additionalInfo == rhs.additionalInfo &&
            lhs.country == rhs.country
    }
}

class CounterpartyBuilder {
    var name:String?
    var streetAndNumber: String?
    var city: String?
    var postalCode: String?
    var taxCode: String?
    var accountNumber: String?
    var additionalInfo: String?
    var country: String?
    
    func withName(_ name: String) -> CounterpartyBuilder {
        self.name = name;
        return self
    }
    
    func withStreetAndNumber(_ streetAndNumber: String) -> CounterpartyBuilder {
        self.streetAndNumber = streetAndNumber
        return self
    }
    
    func withCity(_ city: String) -> CounterpartyBuilder {
        self.city = city;
        return self
    }
    
    func withPostalCode(_ postalCode: String) -> CounterpartyBuilder {
        self.postalCode = postalCode;
        return self
    }
    
    func withTaxCode(_ taxCode: String) -> CounterpartyBuilder {
        self.taxCode = taxCode;
        return self
    }
    
    func withAccountNumber(_ accountNumber: String) -> CounterpartyBuilder {
        self.accountNumber = accountNumber;
        return self
    }
    
    func withAdditionalInfo(_ additionalInfo: String) -> CounterpartyBuilder {
        self.additionalInfo = additionalInfo
        return self
    }
    
    func withCountry(_ country: String) -> CounterpartyBuilder {
        self.country = country
        return self
    }
    
    func build() -> Counterparty {
        return Counterparty(name: name ?? "",
                            streetAndNumber: streetAndNumber ?? "",
                            city: city ?? "",
                            postalCode: postalCode ?? "",
                            taxCode: taxCode ?? "",
                            accountNumber: accountNumber ?? "",
                            additionalInfo: additionalInfo ?? "",
                            country: country ?? "")
    }
}

func aCounterparty() -> CounterpartyBuilder {
    return CounterpartyBuilder()
}
