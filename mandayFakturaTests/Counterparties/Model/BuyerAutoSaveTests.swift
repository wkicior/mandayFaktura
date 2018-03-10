//
//  BuyerAutoSavingTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 20.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest

@testable import mandayFaktura

private class CounterpartyRepositoryMock: CounterpartyRepository {
    func getSeller() -> Counterparty? {
        return nil
    }
    
    func saveSeller(seller: Counterparty) {
        //
    }
    
    func getBuyers() -> [Counterparty] {
        return buyers
    }
    
    func getBuyer(name: String) -> Counterparty? {
        return buyers.first(where: {b in b.name == name})
    }
    
    func addBuyer(buyer: Counterparty) {
        buyers.append(buyer)
    }
    
    func update(buyer: Counterparty) {
        let index = buyers.index(where: {b in b.name == buyer.name})
        buyers[index!] = buyer
    }
    
    private var buyers: [Counterparty] = []
}

class BuyerAutoSaveTests: XCTestCase {
    func testSaveIfNew_saves_new_buyer_on_empty_buyers_repository() throws {
        let counterpartyRepository = CounterpartyRepositoryMock()
        let buyerAutoSave = BuyerAutoSave(counterpartyRepository)
        let buyer = aCounterparty().withName("name").build()
        try buyerAutoSave.saveIfNew(buyer: buyer)
        XCTAssertEqual(1, counterpartyRepository.getBuyers().count)
        XCTAssertEqual(buyer.name, counterpartyRepository.getBuyers()[0].name)
    }
    
    func testSaveIfNew_does_not_save_buyer_if_one_with_that_data_already_exists() throws {
        let counterpartyRepository = CounterpartyRepositoryMock()
        let oldBuyer = aCounterparty().withName("name").build()
        counterpartyRepository.addBuyer(buyer: oldBuyer)
        let buyerAutoSave = BuyerAutoSave(counterpartyRepository)
        let buyer = aCounterparty().withName("name").build()
        try buyerAutoSave.saveIfNew(buyer: buyer)
        XCTAssertEqual(1, counterpartyRepository.getBuyers().count)
        XCTAssertTrue(oldBuyer == counterpartyRepository.getBuyers()[0])
    }
    
    func testSaveIfNew_throws_AnotherBuyerWithThatNameExistsError_on_name_conflict_and_not_mathching_properties() {
        let counterpartyRepository = CounterpartyRepositoryMock()
        counterpartyRepository.addBuyer(buyer: aCounterparty().withName("name").withCity("Warszawa").build())
        let buyerAutoSave = BuyerAutoSave(counterpartyRepository)
        let buyer = aCounterparty().withName("name").withCity("Łódź").build()
        do {
            try buyerAutoSave.saveIfNew(buyer: buyer)
        } catch is AnotherBuyerWithThatNameExistsError {
            return //OK
        } catch {
            XCTFail("AnotherBuyerWithThatNameExistsError exception is expected")
        }
        XCTFail("AnotherBuyerWithThatNameExistsError should have been thrown")
    }
    
    //throws error if same name, but different data
}
