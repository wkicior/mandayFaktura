//
//  InvoicePdfPage.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz

/**
 * Extension providing printing properties of the invoice item on invoice
 */
private extension InvoiceItem {
    static let itemColumnNames = ["Lp", "Nazwa", "Ilość", "jm.", "Cena jdn.", "Wartość Netto", "Stawka VAT", "Kwota VAT", "Wartość Brutto"]
    
    /**
     Return properties list in respectively for itemColumnNames order
     */
    var propertiesForDisplay: [String] {
        get {
            return [self.name, self.amount.description, unitOfMeasureLabel, self.unitNetPrice.description,
                    self.netValue.description, "\(self.vatValueInPercent.description)%", self.vatValue.description, self.grossValue.description]
        }
    }
    
    var unitOfMeasureLabel: String {
        switch self.unitOfMeasure {
        case .hour:
            return "godz."
        case .kg:
            return "kg"
        case .km:
            return "km"
        case .pieces:
            return "szt."
        case .service:
            return "usł."
        }
    }
}

private extension Invoice {
    static let summaryColumnNames = ["Wartość Netto", "Kwota VAT", "Wartość Brutto"]
    
    var propertiesForDisplay: [String] {
        get {
            return [self.totalNetValue.description, self.totalVatValue.description, self.totalGrossValue.description]
        }
    }
    
    var paymentFormLabel: String {
        switch self.paymentForm {
        case .cash:
            return "gotówka"
        case .transfer:
            return "przelew"
        }
    }
}

private extension Decimal {
    var int: Int {
        get {
            let result = NSDecimalNumber(decimal: self)
            return Int(truncating: result)
        }
    }
    
    var fractionalPart: Decimal {
        get {
            return 100 * (self - Decimal(int))
        }
    }
    
    
    var spelledOut: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.spellOut
            var spelledOutInt = numberFormatter.string(from: NSNumber(integerLiteral: self.int))!
            return  "\(spelledOutInt) \(self.fractionalPart.description)/100"
        }
    }
}

class InvoicePdfPage: BasePDFPage {
    let invoice: Invoice
    let dateFormatter = DateFormatter()
    
    let paragraphStyle = NSMutableParagraphStyle()
    let fontAttributesBold: [NSAttributedStringKey: Any]
    let fontBold = NSFont(name: "Helvetica Bold", size: 11.0)
    
    let defaultRowHeight  = CGFloat(50.0)
    let defaultColumnWidth = CGFloat(80.0)

    init(invoice:Invoice, pageNumber:Int) {
        self.invoice = invoice
        self.dateFormatter.timeStyle = .none
        self.dateFormatter.dateStyle = .short
        paragraphStyle.alignment = .left
        
        fontAttributesBold = [
            NSAttributedStringKey.font: fontBold ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:paragraphStyle
        ]

        super.init(pageNumber: pageNumber)
    }
    
    func drawInvoiceHeader() {
        let rect = NSMakeRect(1/2 * self.pdfWidth + CGFloat(100.0), self.pdfHeight - CGFloat(300.0),
                                       1/2 * self.pdfWidth, 1/5 * self.pdfHeight)
        let msg =
        """
        Faktura VAT
        Nr: \(self.invoice.number)
        Data wystawienia: \(self.getDateString(self.invoice.issueDate))
        Data sprzedaży: \(self.getDateString(self.invoice.sellingDate))
        
        
        ORYGINAŁ
        """
        msg.draw(in: rect, withAttributes: fontAttributesBold)
    }
    
    func drawSeller() {
        let rect = NSMakeRect(CGFloat(100.0), self.pdfHeight - CGFloat(450.0),
                              1/2 * self.pdfWidth, 1/5 * self.pdfHeight)
        let msg =
        """
        Sprzedawca:
        \(self.invoice.seller.name)
        \(self.invoice.seller.streetAndNumber)
        \(self.invoice.seller.postalCode) \(self.invoice.seller.city)
        NIP: \(self.invoice.seller.taxCode)
        Nr konta: \(self.invoice.seller.accountNumber)
        """
        msg.draw(in: rect, withAttributes: fontAttributesBold)
    }
    
    func drawBuyer() {
        let rect = NSMakeRect(1/2 * self.pdfWidth, self.pdfHeight - CGFloat(450.0),
                              1/2 * self.pdfWidth, 1/5 * self.pdfHeight)
        let msg =
        """
        Nabywca:
        \(self.invoice.buyer.name)
        \(self.invoice.buyer.streetAndNumber)
        \(self.invoice.buyer.postalCode) \(self.invoice.buyer.city)
        NIP: \(self.invoice.buyer.taxCode)
        """
        msg.draw(in: rect, withAttributes: fontAttributesBold)
    }
    
    func drawItems() {
        drawItemsHeader()
        var itemCounter = 0

        self.invoice.items.forEach { item in
           var propertyCounter = 0
            let properties = [(itemCounter + 1).description] + item.propertiesForDisplay
            properties.forEach { property in
                let rect = NSMakeRect(
                    leftMargin + (CGFloat(propertyCounter) * defaultColumnWidth),
                    self.pdfHeight - CGFloat(550) - (defaultRowHeight * CGFloat(itemCounter)),
                    defaultColumnWidth,
                    defaultRowHeight)
                propertyCounter = propertyCounter + 1
                property.draw(in: rect, withAttributes: fontAttributesBold)
            }
            itemCounter = itemCounter + 1
        }
        self.drawVerticalGrids()
        self.drawHorizontalGrids()
    }
    
    func drawItemsHeader() {
        var counter = 0
        InvoiceItem.itemColumnNames.forEach { name in
            let rect = NSMakeRect(
                leftMargin + (CGFloat(counter) * defaultColumnWidth),
                self.pdfHeight - CGFloat(500),
                defaultColumnWidth,
                defaultRowHeight)
            counter = counter + 1
            name.draw(in: rect, withAttributes: fontAttributesBold)
        }
    }
    
    func drawItemsSummary() {
        drawItemsSummaryHeader()
        var propertyCounter = 0
        (["Razem:"] + self.invoice.propertiesForDisplay).forEach { prop in
            let rect = NSMakeRect(self.pdfWidth / 2 + leftMargin + (CGFloat(propertyCounter) * defaultColumnWidth),
                                  self.pdfHeight - CGFloat(500) - (3 + CGFloat(self.invoice.items.count)) * defaultRowHeight,
                                  defaultColumnWidth,
                                  defaultRowHeight)
            propertyCounter = propertyCounter + 1
            prop.draw(in: rect, withAttributes: fontAttributesBold)
        }
    }
    
    func drawItemsSummaryHeader() {
        var counter = 0
        ([""] + Invoice.summaryColumnNames).forEach { name in
            let rect = NSMakeRect(self.pdfWidth / 2 + leftMargin + (CGFloat(counter) * defaultColumnWidth),
                                  self.pdfHeight - CGFloat(500) - (2 + CGFloat(self.invoice.items.count)) * defaultRowHeight,
                                  defaultColumnWidth,
                                  defaultRowHeight)
            counter = counter + 1
            name.draw(in: rect, withAttributes: fontAttributesBold)
            
        }
    }
    
    func drawPaymentSummary() {
        let rect = NSMakeRect(CGFloat(100.0), self.pdfHeight - CGFloat(500.0) - (7 + CGFloat(self.invoice.items.count)) * defaultRowHeight,
                                1/2 * self.pdfWidth, 1/5 * self.pdfHeight)
        
        let msg =
        """
        Do zapłaty \(self.invoice.totalGrossValue) PLN
        słownie: \(self.invoice.totalGrossValue.spelledOut) PLN
        forma płatności: \(self.invoice.paymentFormLabel)
        termin płatności: \(self.getDateString(self.invoice.paymentDueDate))
        """
        msg.draw(in: rect, withAttributes: fontAttributesBold)
    }
    
    func getDateString(_ date: Date) -> String {
        return self.dateFormatter.string(from: date)
    }
    
    func drawVerticalGrids(){
        for i in 0 ..< InvoiceItem.itemColumnNames.count + 1 {
            let x = leftMargin + (CGFloat(i) * defaultColumnWidth)
            let fromPoint = NSMakePoint(x, self.pdfHeight - CGFloat(500) + defaultRowHeight)
            let toPoint = NSMakePoint(x, self.pdfHeight - CGFloat(500) - (CGFloat(self.invoice.items.count) * defaultRowHeight))
            drawLine(fromPoint: fromPoint, toPoint: toPoint)
        }
    }
    
    func drawHorizontalGrids(){
        let rowCount = self.invoice.items.count + 2
        for i in 0 ..< rowCount {
            let y = self.pdfHeight - CGFloat(500) - (CGFloat(i - 1) * defaultRowHeight)
            let fromPoint = NSMakePoint(leftMargin , y)
            let toPoint = NSMakePoint(self.pdfWidth - rightMargin, y)
            drawLine(fromPoint: fromPoint, toPoint: toPoint)
        }
    }
    
    override func draw(with box: PDFDisplayBox) {
        super.draw(with: box)
        self.drawInvoiceHeader()
        self.drawSeller()
        self.drawBuyer()
        self.drawItems()
        self.drawItemsSummary()
        self.drawPaymentSummary()
    }
}
