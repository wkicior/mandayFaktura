//
//  AbstractBuyerController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class AbstractBuyerController: NSViewController {
    let counterpartyFacade = CounterpartyFacade()
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
    @IBOutlet weak var additionalInfoTextField: NSTextField!

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
    
    func getBuyer() -> Counterparty {
        return aCounterparty()
            .withName(nameTextField.stringValue)
            .withStreetAndNumber(streetTextField.stringValue)
            .withCity(cityTextField.stringValue)
            .withPostalCode(postalCodeTextField.stringValue)
            .withTaxCode(taxCodeTextField.stringValue)
            .withAdditionalInfo(additionalInfoTextField.stringValue)
            .build()
    }
}
