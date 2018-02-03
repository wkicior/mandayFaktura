//
//  PdfInvoice.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz



class InvoicePdf {
    func getDocument() -> PDFDocument {       
        let doc = PDFDocument()
        
        let seller = Counterparty(name: "Firma Krzak", streetAndNumber: "Bolesława 4/12", city: "Warszawka", postalCode: "00-000", taxCode: "123456789", accountNumber:"PL0000111122223333")
        let buyer = Counterparty(name: "Firma XYZ", streetAndNumber: "Miłosza 4/12", city: "Szczebocin", postalCode: "00-000", taxCode: "123456789", accountNumber:"")
        let item1 = InvoiceItem(name: "Usługa informatyczna", amount: Decimal(1), unitOfMeasure: .service, unitNetPrice: Decimal(10000), vatValueInPercent: Decimal(23))
        let item2 = InvoiceItem(name: "Usługa informatyczna 2", amount: Decimal(1), unitOfMeasure: .service, unitNetPrice: Decimal(120), vatValueInPercent: Decimal(8))

        let invoicePage = InvoicePdfPage(invoice: Invoice(issueDate: Date(), number: "NA/12/13", sellingDate: Date(), seller: seller, buyer: buyer, items: [item1, item2]), pageNumber: 1)
        doc.insert(invoicePage, at: 0)
        
        return doc
    }
}
