//
//  Ksef.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03/01/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//
import Foundation
import DYXML


class KsefXml {
    let invoice: Invoice
    init(invoice: Invoice) {
        self.invoice = invoice
    }
    
    enum KsefXmlError: Error {
        case invalidSellerCountry
        case invalidBuyerCountry
    }
    
    func save(dir: URL) throws {
        let fileUrl = dir.appendingPathComponent("Downloads/\(self.invoice.number.encodeToFilename)-ksef-alpha.xml")
        try document().toString(withIndentation: 2).write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
    }
    
    func document() throws -> any XML {
        guard let sellerCountryCode = GovCountryCodes.getCodeByName(countryName: self.invoice.seller.countryOrAssumePoland) else {
            throw KsefXmlError.invalidSellerCountry
        }
        guard let buyerCountryCode = GovCountryCodes.getCodeByName(countryName: self.invoice.buyer.countryOrAssumePoland) else {
            throw KsefXmlError.invalidBuyerCountry
        }
        if !invoice.reverseCharge {
            try self.invoice.items.forEach { try $0.vatRate.toKsefCode() } //validate
        }
       
        return DYXML.document {
            node("Faktura", attributes: [
                ("xmlns", "http://crd.gov.pl/wzor/2025/06/25/13775/"),
            ]) {
                renderHeader()
                renderSeller(sellerCountryCode: sellerCountryCode)
                renderBuyer(buyerCountryCode: buyerCountryCode)
                renderInvoiceCore()
            }
        }
    }
    
    fileprivate func renderHeader() -> XML {
        return node("Naglowek") {
            node("KodFormularza", attributes: [("kodSystemowy", "FA (3)"), ("wersjaSchemy", "1-0E")], value: "FA")
            node("WariantFormularza", value: "3")
            node("DataWytworzeniaFa", value: self.invoice.issueDate.toIsoString())
            node("SystemInfo", value: "mandayFaktura")
        }
    }
    
    fileprivate func renderSeller(sellerCountryCode: String) -> XML {
        return node("Podmiot1") {
            if (self.invoice.reverseCharge) {
                node("PrefiksPodatnika", value: "PL")
            }
            node("DaneIdentyfikacyjne") {
                node("NIP", value: self.invoice.seller.nip)
                node("Nazwa", value: self.invoice.seller.name)
            }
            node("Adres") {
                node("KodKraju", value: sellerCountryCode)
                node("AdresL1", value: self.invoice.seller.streetAndNumber)
                node("AdresL2", value: "\(self.invoice.seller.postalCode) \(self.invoice.seller.city)")
            }
        }
    }
    
    fileprivate func renderBuyer(buyerCountryCode: String) -> XML {
        return node("Podmiot2") {
            node("DaneIdentyfikacyjne") {
                if (self.invoice.reverseCharge) {
                    node("KodUE", value: buyerCountryCode)
                    node("NrVatUE", value: self.invoice.buyer.taxCode.deletingPrefix(buyerCountryCode))
                } else {
                    node("NIP", value: self.invoice.buyer.nip)
                }
                node("Nazwa", value: self.invoice.buyer.name)
            }
            node("Adres") {
                node("KodKraju", value: buyerCountryCode)
                node("AdresL1", value: self.invoice.buyer.streetAndNumber)
                node("AdresL2", value: "\(self.invoice.buyer.postalCode) \(self.invoice.buyer.city)")
            }
            node("JST", value: "2")
            node("GV", value: "2")
        }
    }
    
    fileprivate func renderInvoiceCore() -> XML {
        return node("Fa") {
            node("KodWaluty", value: self.invoice.currency.rawValue)
            node("P_1", value: self.invoice.issueDate.toDateBigEndianDashString())
            node("P_2", value: self.invoice.number)
            node("P_6", value: self.invoice.sellingDate.toDateBigEndianDashString())
            if (invoice.reverseCharge) {
                node("P_13_8", value: self.invoice.totalNetValue.formatAmountDot())
                node("P_13_10", value: self.invoice.totalNetValue.formatAmountDot())
            } else {
                if (self.invoice.totalNetValue(forVatRates: [VatRate(string: "23%"), VatRate(string: "22%")]) > 0) {
                    node("P_13_1", value: self.invoice.totalNetValue(forVatRates: [
                        VatRate(string: "23%"), VatRate(string: "22%")]).formatAmountDot())
                    node("P_14_1", value: self.invoice.totalVatValue(forVatRates: [
                        VatRate(string: "23%"), VatRate(string: "22%")]).formatAmountDot())
                }
                if (self.invoice.totalNetValue(forVatRates: [VatRate(string: "8%"), VatRate(string: "7%")]) > 0) {
                    node("P_13_2", value: self.invoice.totalNetValue(forVatRates: [
                        VatRate(string: "8%"), VatRate(string: "7%")]).formatAmountDot())
                    node("P_14_2", value: self.invoice.totalVatValue(forVatRates: [
                        VatRate(string: "8%"), VatRate(string: "7%")]).formatAmountDot())
                }
                if (self.invoice.totalNetValue(forVatRates: [VatRate(string: "5%")]) > 0 ) {
                    node("P_13_3", value: self.invoice.totalNetValue(forVatRates: [
                        VatRate(string: "5%")]).formatAmountDot())
                    node("P_14_3", value: self.invoice.totalVatValue(forVatRates: [
                        VatRate(string: "5%")]).formatAmountDot())
                }
                if (self.invoice.totalNetValue(forVatRates: [VatRate(string: "0 KR")]) > 0 ) {
                    node("P_13_6_1", value: self.invoice.totalNetValue(forVatRates: [
                        VatRate(string: "0 KR")]).formatAmountDot())
                }
            }
            node("P_15", value: self.invoice.totalGrossValue.formatAmountDot())
            renderAnnotations()
            node("RodzajFaktury", value: "VAT")
            if !additionalRemarks.isEmpty {
                node("DodatkowyOpis") {
                    node("Klucz", value: "Uwagi")
                    node("Wartosc", value: additionalRemarks)
                }
            }
            for (index, item) in invoice.items.enumerated() {
                renderInvoiceItem(index, item)
            }
            renderPaymentDetails()
        }
    }
    
    
    fileprivate func renderAnnotations() -> XML {
        return node("Adnotacje") {
            node("P_16", value: "2")
            node("P_17", value: "2")
            node("P_18", value: self.invoice.reverseCharge ? "1" : "2")
            node("P_18A", value: "2")
            node("Zwolnienie") {
                node("P_19N", value: "1")
            }
            node("NoweSrodkiTransportu") {
                node("P_22N", value: "1")
            }
            node("P_23", value: "2")
            node("PMarzy") {
                node("P_PMarzyN", value: "1")
            }
        }
    }
    
    fileprivate func renderInvoiceItem(_ index: Int, _ item: InvoiceItem) -> XML {
        return node("FaWiersz") {
            node("NrWierszaFa", value: "\(index + 1)")
            node("P_7", value: item.name)
            node("P_8A", value: item.unitOfMeasureLabel(primaryLanguage: .PL, secondaryLanguage: nil, isI10n: false))
            node("P_8B", value: "\(item.amount)")
            node("P_9A", value: item.unitNetPrice.formatAmountDot())
            node("P_11", value: item.netValue.formatAmountDot())
            node("P_11Vat", value: item.vatValue.formatAmountDot())
            if invoice.reverseCharge {
                node("P_12", value: "oo")
            } else {
                node("P_12", value: try! item.vatRate.toKsefCode())
            }
        }
    }
    
    fileprivate func renderPaymentDetails() -> XML {
        return node("Platnosc") {
            node("TerminPlatnosci") {
                node("Termin", value: invoice.paymentDueDate.toDateBigEndianDashString())
            }
            node("FormaPlatnosci", value: "\(invoice.paymentForm.toKsefCode())")
            if (invoice.paymentForm == .transfer) {
                node("RachunekBankowy") {
                    node("NrRB", value: invoice.seller.accountNumber.filter{!$0.isWhitespace})
                }
            }
        }
    }
    
    private var additionalRemarks: String {
        get {
            var additionalRemarks = "\(self.invoice.reverseCharge ? "Odwrotne obciążenie" : "")"
            if (!additionalRemarks.isBlank && !self.invoice.notes.isBlank) {
                additionalRemarks = "\(additionalRemarks)\n\(self.invoice.notes)"
            } else if (!self.invoice.notes.isBlank) {
                additionalRemarks = self.invoice.notes
            }
            return additionalRemarks
        }
    }
}

