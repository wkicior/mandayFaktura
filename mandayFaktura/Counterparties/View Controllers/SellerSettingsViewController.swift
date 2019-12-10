//
//  SellerSettingsViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 13.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class SellerSettingsViewController: NSViewController {
    let counterpartyFacade = CounterpartyFacade()
    @IBOutlet weak var streetAndNumberTextField: NSTextField!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var postalCodeTextField: NSTextField!
    @IBOutlet weak var cityTextCode: NSTextField!
    @IBOutlet weak var taxCodeTextField: NSTextField!
    @IBOutlet weak var accountNumberTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let seller = counterpartyFacade.getSeller()
        fillFieldsFromSeller(seller)
    }
    
   
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        let counterparty = buildSellerFromFields()
        counterpartyFacade.saveSeller(seller: counterparty)
        view.window?.close()
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        view.window?.close()
    }
    
    fileprivate func fillFieldsFromSeller(_ seller: Counterparty?) {
        nameTextField.stringValue = seller?.name ?? ""
        streetAndNumberTextField.stringValue = seller?.streetAndNumber ?? ""
        postalCodeTextField.stringValue = seller?.postalCode ?? ""
        cityTextCode.stringValue = seller?.city ?? ""
        taxCodeTextField.stringValue = seller?.taxCode ?? ""
        accountNumberTextField.stringValue = seller?.accountNumber ?? ""
    }
    
    fileprivate func buildSellerFromFields() -> Counterparty {
        return aCounterparty()
            .withName(nameTextField.stringValue)
            .withCity(cityTextCode.stringValue)
            .withTaxCode(taxCodeTextField.stringValue)
            .withPostalCode(postalCodeTextField.stringValue)
            .withAccountNumber(accountNumberTextField.stringValue)
            .withStreetAndNumber(streetAndNumberTextField.stringValue)
            .build()
    }
}
