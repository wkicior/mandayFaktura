//
//  InvoiceNumberingSettingsViewControllerTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 25.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura

class NumberingSegmentTypeTests: XCTestCase {
    func testValidateFixedPart_will_throw_validation_exception_on_empty_field() {
        do {
            try NumberingSegmentType.validateFixedPart(value: "")
        } catch InputValidationError.invalidNumber( _) {
           return
        } catch {
            //
        }
        XCTFail("exception should have been thrown")
    }
    
    func testValidateFixedPart_will_throw_validation_exception_on_not_valid_value() {
        do {
            try NumberingSegmentType.validateFixedPart(value: "ab?123")
        } catch InputValidationError.invalidNumber( _) {
            return
        } catch {
            //
        }
        XCTFail("exception should have been thrown")
    }
    
    func testValidateFixedPart_will_pass_on_numbers_and_letters() {
        try! NumberingSegmentType.validateFixedPart(value: "aB01")
    }
}
