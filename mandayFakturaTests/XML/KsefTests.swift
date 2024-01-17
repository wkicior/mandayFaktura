//
//  KsefTests.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04/01/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura


class KsefTests: XCTestCase {
    func testKsefXmlPl() {
        XCTAssertEqual("TODO", "TMP", "KSeF XML file must match")
    }
    
    func testKsefXmlKoryg() {
        XCTAssertEqual("TODO", "TMP", "KSeF XML file must match")
    }
    
    func testKsefXmlEu() {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let issueDate = formatter.date(from: "2024-01-02T21:42:22.000+01:00")!
        let sellingDate = formatter.date(from: "2024-01-01T21:42:22.000+01:00")!
        let paymentDueDate = formatter.date(from: "2024-02-16T12:32:22.0000+01:00")!

        let expectedTmp = """
<?xml version="1.0" encoding="UTF-8"?>
<Faktura xmlns="http://crd.gov.pl/wzor/2023/06/29/12648/">
  <Naglowek>
    <KodFormularza kodSystemowy="FA (2)" wersjaSchemy="1-0E">FA</KodFormularza>
    <WariantFormularza>2</WariantFormularza>
    <DataWytworzeniaFa>2024-01-02T21:42:22.000+01:00</DataWytworzeniaFa>
    <SystemInfo>mandayFaktura</SystemInfo>
  </Naglowek>
  <Podmiot1>
    <PrefiksPodatnika>PL</PrefiksPodatnika>
    <DaneIdentyfikacyjne>
      <NIP>5671234567</NIP>
      <Nazwa>Januszex sp. z o.o.</Nazwa>
    </DaneIdentyfikacyjne>
    <Adres>
      <KodKraju>PL</KodKraju>
      <AdresL1>Jana Pawła Adamczewskiego 16/70</AdresL1>
      <AdresL2>11-234 Adamczycha</AdresL2>
    </Adres>
  </Podmiot1>
  <Podmiot2>
    <DaneIdentyfikacyjne>
      <KodUE>DK</KodUE>
      <NrVatUE>5566778899</NrVatUE>
      <Nazwa>ACME Company ApS</Nazwa>
    </DaneIdentyfikacyjne>
    <Adres>
      <KodKraju>DK</KodKraju>
      <AdresL1>Oesterballevej 15</AdresL1>
      <AdresL2>7000 MIddelfart</AdresL2>
    </Adres>
  </Podmiot2>
  <Fa>
    <KodWaluty>PLN</KodWaluty>
    <P_1>2024-01-02</P_1>
    <P_2>1/A/2024</P_2>
    <P_6>2024-01-01</P_6>
    <P_13_8>300.02</P_13_8>
    <P_13_10>300.02</P_13_10>
    <P_15>300.02</P_15>
    <Adnotacje>
      <P_16>2</P_16>
      <P_17>2</P_17>
      <P_18>1</P_18>
      <P_18A>2</P_18A>
      <Zwolnienie>
        <P_19N>1</P_19N>
      </Zwolnienie>
      <NoweSrodkiTransportu>
        <P_22N>1</P_22N>
      </NoweSrodkiTransportu>
      <P_23>2</P_23>
      <PMarzy>
        <P_PMarzyN>1</P_PMarzyN>
      </PMarzy>
    </Adnotacje>
    <RodzajFaktury>VAT</RodzajFaktury>
    <DodatkowyOpis>
      <Klucz>Uwagi</Klucz>
      <Wartosc>Odwrotne obciążenie</Wartosc>
    </DodatkowyOpis>
    <FaWiersz>
      <NrWierszaFa>1</NrWierszaFa>
      <P_7>IT Service | Usługa informatyczna</P_7>
      <P_8A>godz.</P_8A>
      <P_8B>2</P_8B>
      <P_9A>150.01</P_9A>
      <P_11>300.02</P_11>
      <P_11Vat>0</P_11Vat>
      <P_12>oo</P_12>
    </FaWiersz>
    <Platnosc>
      <TerminPlatnosci>
        <Termin>2024-02-16</Termin>
      </TerminPlatnosci>
      <FormaPlatnosci>6</FormaPlatnosci>
      <RachunekBankowy>
        <NrRB>PL91068552731823476708578737</NrRB>
      </RachunekBankowy>
    </Platnosc>
  </Fa>
</Faktura>

"""
         let ksefXml = KsefXml(anInvoice()
            .withIssueDate(issueDate)
            .withItems([])
            .withNumber("1/A/2024")
            .withSellingDate(sellingDate)
            .withNotes("Odwrotne obciążenie")
            .withReverseCharge(true)
            .withPaymentDueDate(paymentDueDate)
            .withPaymentForm(PaymentForm.transfer)
            .withSeller(aCounterparty()
                .withName("Januszex sp. z o.o.")
                .withTaxCode("PL5671234567")
                .withStreetAndNumber("Jana Pawła Adamczewskiego 16/70")
                .withCountry("Polska")
                .withPostalCode("11-234")
                .withCity("Adamczycha")
                .withAccountNumber("PL91068552731823476708578737")
                .build())
            .withBuyer(aCounterparty()
                .withName("ACME Company ApS")
                .withStreetAndNumber("Oesterballevej 15")
                .withPostalCode("7000")
                .withCity("MIddelfart")
                .withCountry("Dania")
                .withTaxCode("DK5566778899")
                .build())
                .withItems([anInvoiceItem().withAmount(2).withName("IT Service | Usługa informatyczna").withUnitOfMeasure(UnitOfMeasure.hour).withUnitNetPrice(150.01).build()])
            .build())
        XCTAssertEqual(expectedTmp, try ksefXml.document().toString(withIndentation: 2), "KSeF XML file must match")
    }
    
    
}
