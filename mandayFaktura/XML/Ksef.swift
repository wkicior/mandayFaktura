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
    init(_ invoice: Invoice) {
        self.invoice = invoice
    }
    
    enum KsefXmlError: Error {
            case invalidSellerCountry
            case invalidBuyerCountry
        }
    
    func document() throws -> any XML {
        guard let sellerCountryCode = GovCountryCodes.getCodeByName(countryName: self.invoice.seller.country) else {
            throw KsefXmlError.invalidSellerCountry
        }
        guard let buyerCountryCode = GovCountryCodes.getCodeByName(countryName: self.invoice.buyer.country) else {
            throw KsefXmlError.invalidBuyerCountry
        }
        return DYXML.document {
            node("Faktura", attributes: [
                ("xmlns", "http://crd.gov.pl/wzor/2023/06/29/12648/"),
            ]) {
                node("Naglowek") {
                    node("KodFormularza", attributes: [("kodSystemowy", "FA (2)"), ("wersjaSchemy", "1-0E")], value: "FA")
                    node("WariantFormularza", value: "2")
                    node("DataWytworzeniaFa", value: self.invoice.issueDate.toIsoString())
                    node("SystemInfo", value: "mandayFaktura")
                }
                node("Podmiot1") {
                    node("PrefiksPodatnika", value: "PL")
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
                node("Podmiot2") {
                    node("DaneIdentyfikacyjne") {
                        node("KodUE", value: buyerCountryCode)
                        node("NrVatUE", value: self.invoice.buyer.taxCode.deletingPrefix(buyerCountryCode))
                        node("Nazwa", value: self.invoice.buyer.name)
                    }
                    node("Adres") {
                        node("KodKraju", value: buyerCountryCode)
                        node("AdresL1", value: "Oesterballevej 15")
                        node("AdresL2", value: "\(self.invoice.buyer.postalCode) \(self.invoice.buyer.city)")
                    }
                }
                node("Fa") {
                    node("KodWaluty", value: "PLN")
                    node("P_1", value: self.invoice.issueDate.toDateBigEndianDashString())
                    node("P_2", value: self.invoice.number)
                    node("P_6", value: self.invoice.sellingDate.toDateBigEndianDashString())
                    node("P_13_8", value: self.invoice.totalNetValue.formatAmountDot())
                    node("P_13_10", value: self.invoice.totalNetValue.formatAmountDot())
                    node("P_15", value: self.invoice.totalGrossValue.formatAmountDot())
                    node("Adnotacje") {
                        node("P_16", value: "2")
                        node("P_17", value: "2")
                        node("P_18", value: "1")
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
                    node("RodzajFaktury", value: "VAT")
                    if !invoice.notes.isEmpty {
                        node("DodatkowyOpis") {
                            node("Klucz", value: "Uwagi")
                            node("Wartosc", value: invoice.notes)
                        }
                    }
                    for (index, item) in invoice.items.enumerated() {
                        node("FaWiersz") {
                            node("NrWierszaFa", value: "\(index + 1)")
                            node("P_7", value: item.name)
                            node("P_8A", value: item.unitOfMeasureLabel(isI10n: false))
                            node("P_8B", value: "\(item.amount)")
                            node("P_9A", value: item.unitNetPrice.formatAmountDot())
                            node("P_11", value: item.netValue.formatAmountDot())
                            node("P_11Vat", value: item.vatValue.formatAmountDot())
                            if invoice.reverseCharge {
                                node("P_12", value: "oo")
                            }
                        }
                    }
                    node("Platnosc") {
                        node("TerminPlatnosci") {
                            node("Termin", value: invoice.paymentDueDate.toDateBigEndianDashString())
                        }
                        node("FormaPlatnosci", value: "\(invoice.paymentForm.toKsefCode())")
                        if (invoice.paymentForm == .transfer) {
                            node("RachunekBankowy") {
                                node("NrRB", value: invoice.seller.accountNumber)
                            }
                        }
                    }
                }
            }
        }
    }
}

