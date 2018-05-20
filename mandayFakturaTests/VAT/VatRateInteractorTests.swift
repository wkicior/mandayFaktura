//
//  VatRateInteractorTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 19.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

import XCTest
@testable import mandayFaktura

class VatRateRepositoryMocked: VatRateRepository {
    var vatRates = [VatRate(value: 0)]
    var deleteCalled = false
    func getVatRates() -> [VatRate] {
        return vatRates
    }
    
    func getDefaultVatRate() -> VatRate? {
        return nil
    }
    
    func saveVatRates(vatRates: [VatRate]) {
        self.vatRates = vatRates
    }
    
    func delete(_ vatRate: VatRate) {
        deleteCalled = true
    }
}

class VatRateInteractorTests: XCTestCase {
    let vatRateRepositoryMocked = VatRateRepositoryMocked()
    func testGetVatRates() {
        let vatRateInteractor = VatRateInteractor(vatRateRepository: vatRateRepositoryMocked)
        let vatRates:[VatRate] = vatRateInteractor.getVatRates()
        XCTAssertEqual(vatRateRepositoryMocked.getVatRates(), vatRates)
    }
    
    func testDelete() {
        let vatRateInteractor = VatRateInteractor(vatRateRepository: vatRateRepositoryMocked)
        vatRateInteractor.delete(VatRate(value: 0))
        XCTAssertTrue(vatRateRepositoryMocked.deleteCalled)
    }
    
    func testSetDefault_unsetsDefault() {
        let vatRateInteractor = VatRateInteractor(vatRateRepository: vatRateRepositoryMocked)
        vatRateInteractor.setDefault(isDefault: false, vatRate: VatRate(value: 0, isDefault: true))
        XCTAssertFalse(vatRateRepositoryMocked.vatRates[0].isDefault)
    }
    
    func testSetDefault_setsDefaultForOnlyOneElement() {
        let vatRateInteractor = VatRateInteractor(vatRateRepository: vatRateRepositoryMocked)
        vatRateInteractor.setDefault(isDefault: true, vatRate: VatRate(value: 0))
        XCTAssertTrue(vatRateRepositoryMocked.vatRates[0].isDefault)
    }
    
    func testSetDefault_setsDefaultForSelectedElementAndUnsetsForTheRest() {
        let vatRateInteractor = VatRateInteractor(vatRateRepository: vatRateRepositoryMocked)
        let vatRates = [VatRate(value: 1, isDefault: true), VatRate(value: 0)]
        vatRateRepositoryMocked.saveVatRates(vatRates: vatRates)
        vatRateInteractor.setDefault(isDefault: true, vatRate: VatRate(value: 0))
        XCTAssertFalse(vatRateRepositoryMocked.vatRates[0].isDefault)
        XCTAssertTrue(vatRateRepositoryMocked.vatRates[1].isDefault)
    }
}
