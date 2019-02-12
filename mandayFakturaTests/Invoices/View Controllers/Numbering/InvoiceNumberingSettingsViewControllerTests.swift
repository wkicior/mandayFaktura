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

class InvoiceNumberingSettingsViewControllerTests: XCTestCase {
    func testValidateFixedPart_will_throw_validation_exception_on_empty_field() {
        let controller = InvoiceNumberingSettingsViewController()
        let textField = NSTextField(labelWithString: "")
        controller.fixedPartTextField = textField

        do {
            try controller.validateFixedPart()
        } catch InputValidationError.invalidNumber( _) {
           return
        } catch {
            //
        }
        XCTFail("exception should have been thrown")
    }
    
    func testValidateFixedPart_will_throw_validation_exception_on_not_valid_value() {
        let controller = InvoiceNumberingSettingsViewController()
        let textField = NSTextField(labelWithString: "ab?123")
        controller.fixedPartTextField = textField
        
        do {
            try controller.validateFixedPart()
        } catch InputValidationError.invalidNumber( _) {
            return
        } catch {
            //
        }
        XCTFail("exception should have been thrown")
    }
    
    func testValidateFixedPart_will_pass_on_numbers_and_letters() {
        let controller = InvoiceNumberingSettingsViewController()
        let textField = NSTextField(labelWithString: "aB01")
        controller.fixedPartTextField = textField
        try! controller.validateFixedPart()
    }
}
