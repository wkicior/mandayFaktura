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


class KsefXmlTests: XCTestCase {
    func testKsefXmlPl() {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let issueDate = formatter.date(from: "2026-01-02T21:42:22.000+01:00")!
        let sellingDate = formatter.date(from: "2026-01-01T21:42:22.000+01:00")!
        let paymentDueDate = formatter.date(from: "2026-02-16T12:32:22.0000+01:00")!
        let expectedTmp = """
<?xml version="1.0" encoding="UTF-8"?>
<Faktura xmlns="http://crd.gov.pl/wzor/2025/06/25/13775/">
  <Naglowek>
    <KodFormularza kodSystemowy="FA (3)" wersjaSchemy="1-0E">FA</KodFormularza>
    <WariantFormularza>3</WariantFormularza>
    <DataWytworzeniaFa>2026-01-02T21:42:22.000+01:00</DataWytworzeniaFa>
    <SystemInfo>mandayFaktura</SystemInfo>
  </Naglowek>
  <Podmiot1>
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
      <NIP>3581635532</NIP>
      <Nazwa>Prywaciarz SA</Nazwa>
    </DaneIdentyfikacyjne>
    <Adres>
      <KodKraju>PL</KodKraju>
      <AdresL1>Mirkowska 69</AdresL1>
      <AdresL2>81-537 Gdynia</AdresL2>
    </Adres>
    <JST>2</JST>
    <GV>2</GV>
  </Podmiot2>
  <Fa>
    <KodWaluty>PLN</KodWaluty>
    <P_1>2026-01-02</P_1>
    <P_2>1/A/2026</P_2>
    <P_6>2026-01-01</P_6>
    <P_13_1>100.15</P_13_1>
    <P_14_1>23.03</P_14_1>
    <P_15>123.18</P_15>
    <Adnotacje>
      <P_16>2</P_16>
      <P_17>2</P_17>
      <P_18>2</P_18>
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
      <Wartosc>Wystawił: Jan Kowalski</Wartosc>
    </DodatkowyOpis>
    <FaWiersz>
      <NrWierszaFa>1</NrWierszaFa>
      <P_7>Usługa informatyczna</P_7>
      <P_8A>godz.</P_8A>
      <P_8B>1</P_8B>
      <P_9A>100.15</P_9A>
      <P_11>100.15</P_11>
      <P_11Vat>23.03</P_11Vat>
      <P_12>23</P_12>
    </FaWiersz>
    <Platnosc>
      <TerminPlatnosci>
        <Termin>2026-02-16</Termin>
      </TerminPlatnosci>
      <FormaPlatnosci>6</FormaPlatnosci>
      <RachunekBankowy>
        <NrRB>PL91068552731823476708578737</NrRB>
      </RachunekBankowy>
    </Platnosc>
  </Fa>
</Faktura>

"""
        let ksefXml = KsefXml(invoice: anInvoice()
            .withIssueDate(issueDate)
            .withItems([])
            .withNumber("1/A/2026")
            .withSellingDate(sellingDate)
            .withNotes("Wystawił: Jan Kowalski")
            .withPaymentDueDate(paymentDueDate)
            .withPaymentForm(PaymentForm.transfer)
            .withSeller(aCounterparty()
                .withName("Januszex sp. z o.o.")
                .withTaxCode("PL5671234567")
                .withStreetAndNumber("Jana Pawła Adamczewskiego 16/70")
                .withPostalCode("11-234")
                .withCity("Adamczycha")
                .withAccountNumber("PL 9106 8552 7318 2347 6708 5787 37")
                .build())
                .withBuyer(aCounterparty()
                    .withName("Prywaciarz SA")
                    .withStreetAndNumber("Mirkowska 69")
                    .withPostalCode("81-537")
                    .withCity("Gdynia")
                    .withTaxCode("3581635532")
                    .build())
                    .withItems([anInvoiceItem().withAmount(1).withName("Usługa informatyczna")
                        .withVatRate(VatRate(string: "23%")).withUnitOfMeasure(UnitOfMeasure.hour)
                        .withUnitNetPrice(100.15).build()])
                        .build())
        XCTAssertEqual(expectedTmp, try ksefXml.document().toString(withIndentation: 2), "KSeF XML file must match")
    }
    
    func testKsefXmlPlOtherVatRatesAndOtherFields() {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let issueDate = formatter.date(from: "2026-02-10T21:29:22.000+01:00")!
        let sellingDate = formatter.date(from: "2026-02-10T21:42:22.000+01:00")!
        let paymentDueDate = formatter.date(from: "2026-03-26T12:32:22.0000+01:00")!
        let expected = """
<?xml version="1.0" encoding="UTF-8"?>
<Faktura xmlns="http://crd.gov.pl/wzor/2025/06/25/13775/">
  <Naglowek>
    <KodFormularza kodSystemowy="FA (3)" wersjaSchemy="1-0E">FA</KodFormularza>
    <WariantFormularza>3</WariantFormularza>
    <DataWytworzeniaFa>2026-02-10T21:29:22.000+01:00</DataWytworzeniaFa>
    <SystemInfo>mandayFaktura</SystemInfo>
  </Naglowek>
  <Podmiot1>
    <DaneIdentyfikacyjne>
      <NIP>5671234568</NIP>
      <Nazwa>Areczex sp. z o.o.</Nazwa>
    </DaneIdentyfikacyjne>
    <Adres>
      <KodKraju>PL</KodKraju>
      <AdresL1>Jana Pawła Adamczewskiego 161/70</AdresL1>
      <AdresL2>10-234 Adamczycha</AdresL2>
    </Adres>
  </Podmiot1>
  <Podmiot2>
    <DaneIdentyfikacyjne>
      <NIP>3581635532</NIP>
      <Nazwa>Mireczek SA</Nazwa>
    </DaneIdentyfikacyjne>
    <Adres>
      <KodKraju>PL</KodKraju>
      <AdresL1>Januszowska 69</AdresL1>
      <AdresL2>81-537 Gdynia</AdresL2>
    </Adres>
    <JST>2</JST>
    <GV>2</GV>
  </Podmiot2>
  <Fa>
    <KodWaluty>PLN</KodWaluty>
    <P_1>2026-02-10</P_1>
    <P_2>1/A/2026</P_2>
    <P_6>2026-02-10</P_6>
    <P_13_1>1600.69</P_13_1>
    <P_14_1>368.16</P_14_1>
    <P_13_2>160.8</P_13_2>
    <P_14_2>12.86</P_14_2>
    <P_13_6_1>13000</P_13_6_1>
    <P_15>15143.5</P_15>
    <Adnotacje>
      <P_16>2</P_16>
      <P_17>2</P_17>
      <P_18>2</P_18>
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
    <FaWiersz>
      <NrWierszaFa>1</NrWierszaFa>
      <P_7>Towar 1</P_7>
      <P_8A>szt.</P_8A>
      <P_8B>13</P_8B>
      <P_9A>123.13</P_9A>
      <P_11>1600.69</P_11>
      <P_11Vat>368.16</P_11Vat>
      <P_12>23</P_12>
    </FaWiersz>
    <FaWiersz>
      <NrWierszaFa>2</NrWierszaFa>
      <P_7>Towar 2</P_7>
      <P_8A>godz.</P_8A>
      <P_8B>13.4</P_8B>
      <P_9A>12</P_9A>
      <P_11>160.8</P_11>
      <P_11Vat>12.86</P_11Vat>
      <P_12>8</P_12>
    </FaWiersz>
    <FaWiersz>
      <NrWierszaFa>3</NrWierszaFa>
      <P_7>Towar 3</P_7>
      <P_8A>szt.</P_8A>
      <P_8B>1</P_8B>
      <P_9A>0.99</P_9A>
      <P_11>0.99</P_11>
      <P_11Vat>0</P_11Vat>
      <P_12>np I</P_12>
    </FaWiersz>
    <FaWiersz>
      <NrWierszaFa>4</NrWierszaFa>
      <P_7>Towar 4</P_7>
      <P_8A>szt.</P_8A>
      <P_8B>1</P_8B>
      <P_9A>13000</P_9A>
      <P_11>13000</P_11>
      <P_11Vat>0</P_11Vat>
      <P_12>0 KR</P_12>
    </FaWiersz>
    <Platnosc>
      <TerminPlatnosci>
        <Termin>2026-03-26</Termin>
      </TerminPlatnosci>
      <FormaPlatnosci>1</FormaPlatnosci>
    </Platnosc>
  </Fa>
</Faktura>

"""
        let ksefXml = KsefXml(invoice: anInvoice()
            .withIssueDate(issueDate)
            .withItems([])
            .withNumber("1/A/2026")
            .withSellingDate(sellingDate)
            .withPaymentDueDate(paymentDueDate)
            .withPaymentForm(PaymentForm.cash)
            .withSeller(aCounterparty()
                .withName("Areczex sp. z o.o.")
                .withTaxCode("5671234568")
                .withStreetAndNumber("Jana Pawła Adamczewskiego 161/70")
                .withPostalCode("10-234")
                .withCity("Adamczycha")
                .withAccountNumber("PL 9106 8552 7318 2347 6708 5787 37")
                .build())
                .withBuyer(aCounterparty()
                    .withName("Mireczek SA")
                    .withStreetAndNumber("Januszowska 69")
                    .withPostalCode("81-537")
                    .withCity("Gdynia")
                    .withTaxCode("3581635532")
                    .build())
                .withItems([
                    anInvoiceItem()
                        .withName("Towar 1")
                        .withAmount(13)
                        .withUnitOfMeasure(UnitOfMeasure.pieces)
                        .withVatRate(VatRate(string: "23%"))
                        .withUnitNetPrice(123.13).build(),
                    anInvoiceItem()
                        .withName("Towar 2")
                        .withAmount(13.4)
                        .withUnitOfMeasure(UnitOfMeasure.hour)
                        .withVatRate(VatRate(string: "8%"))
                        .withUnitNetPrice(12).build(),
                    anInvoiceItem()
                        .withName("Towar 3")
                        .withAmount(1)
                        .withUnitOfMeasure(UnitOfMeasure.pieces)
                        .withVatRate(VatRate(string: "np I"))
                        .withUnitNetPrice(0.99).build(),
                    anInvoiceItem()
                        .withName("Towar 4")
                        .withAmount(1)
                        .withUnitOfMeasure(UnitOfMeasure.pieces)
                        .withVatRate(VatRate(string: "0 KR"))
                        .withUnitNetPrice(13000).build(),
                ])
                .build())
        XCTAssertEqual(expected, try ksefXml.document().toString(withIndentation: 2), "KSeF XML file must match")
    }
    
    func testKsefXmlEu() {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let issueDate = formatter.date(from: "2026-01-02T21:42:22.000+01:00")!
        let sellingDate = formatter.date(from: "2026-01-01T21:42:22.000+01:00")!
        let paymentDueDate = formatter.date(from: "2026-02-16T12:32:22.0000+01:00")!

        let expectedTmp = """
<?xml version="1.0" encoding="UTF-8"?>
<Faktura xmlns="http://crd.gov.pl/wzor/2025/06/25/13775/">
  <Naglowek>
    <KodFormularza kodSystemowy="FA (3)" wersjaSchemy="1-0E">FA</KodFormularza>
    <WariantFormularza>3</WariantFormularza>
    <DataWytworzeniaFa>2026-01-02T21:42:22.000+01:00</DataWytworzeniaFa>
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
    <JST>2</JST>
    <GV>2</GV>
  </Podmiot2>
  <Fa>
    <KodWaluty>PLN</KodWaluty>
    <P_1>2026-01-02</P_1>
    <P_2>1/A/2026</P_2>
    <P_6>2026-01-01</P_6>
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
      <Wartosc>Odwrotne obciążenie
Wystawił: Jan Kowalski</Wartosc>
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
        <Termin>2026-02-16</Termin>
      </TerminPlatnosci>
      <FormaPlatnosci>6</FormaPlatnosci>
      <RachunekBankowy>
        <NrRB>PL91068552731823476708578737</NrRB>
      </RachunekBankowy>
    </Platnosc>
  </Fa>
</Faktura>

"""
        let ksefXml = KsefXml(invoice: anInvoice()
            .withIssueDate(issueDate)
            .withItems([])
            .withNumber("1/A/2026")
            .withSellingDate(sellingDate)
            .withNotes("Wystawił: Jan Kowalski")
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
                .withAccountNumber("PL 9106 8552 7318 2347 6708 5787 37")
                .build())
            .withBuyer(aCounterparty()
                .withName("ACME Company ApS")
                .withStreetAndNumber("Oesterballevej 15")
                .withPostalCode("7000")
                .withCity("MIddelfart")
                .withCountry("Dania")
                .withTaxCode("DK5566778899")
                .build())
                .withItems([anInvoiceItem().withAmount(2)
                    .withName("IT Service | Usługa informatyczna")
                    .withVatRate(VatRate(string: "NP"))
                    .withUnitOfMeasure(UnitOfMeasure.hour).withUnitNetPrice(150.01).build()])
            .build())
        XCTAssertEqual(expectedTmp, try ksefXml.document().toString(withIndentation: 2), "KSeF XML file must match")
    }
}
