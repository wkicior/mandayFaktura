//
//  NewBuyerController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 09.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

struct NewBuyerViewControllerConstants {
    static let BUYER_ADDED_NOTIFICATION = Notification.Name(rawValue: "BuyerAdded")
}

class NewBuyerController: NSViewController {
    let counterpartyRepository = CounterpartyRepositoryFactory.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name:NSControl.textDidChangeNotification, object: nil)
    }
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var streetTextField: NSTextField!
    @IBOutlet weak var postalCodeTextField: NSTextField!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var taxCodeTextField: NSTextField!
    @IBAction func onSaveButtonClickedAction(_ sender: Any) {
        let buyer = aCounterparty()
            .withName(nameTextField.stringValue)
            .withStreetAndNumber(streetTextField.stringValue)
            .withCity(cityTextField.stringValue)
            .withPostalCode(postalCodeTextField.stringValue)
            .withTaxCode(taxCodeTextField.description)
            .build()
        counterpartyRepository.addBuyer(buyer: buyer)
        NotificationCenter.default.post(name: NewBuyerViewControllerConstants.BUYER_ADDED_NOTIFICATION, object: buyer)
        view.window?.close()
    }
    @IBAction func onCancelButtonClickedAction(_ sender: Any) {
         view.window?.close()
    }
    
    @objc func textFieldDidChange(_ notification: Notification) {
        checkSaveButtonEnabled()
    }
    
    private func checkSaveButtonEnabled() {
        self.saveButton.isEnabled = !self.nameTextField.stringValue.isEmpty
            && !self.streetTextField.stringValue.isEmpty
            && !self.postalCodeTextField.stringValue.isEmpty
            && !self.taxCodeTextField.stringValue.isEmpty
            && !self.cityTextField.stringValue.isEmpty
    }
}
