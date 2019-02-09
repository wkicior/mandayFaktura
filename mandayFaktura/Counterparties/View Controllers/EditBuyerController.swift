//
//  EditBuyerController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 12.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

struct EditBuyerViewControllerConstants {
    static let BUYER_EDITED_NOTIFICATION = Notification.Name(rawValue: "BuyerEdited")
}

class EditBuyerController: AbstractBuyerController {
    var buyer: Counterparty?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.stringValue = buyer!.name
        self.streetTextField.stringValue = buyer!.streetAndNumber
        self.postalCodeTextField.stringValue = buyer!.postalCode
        self.cityTextField.stringValue = buyer!.city
        self.taxCodeTextField.stringValue = buyer!.taxCode
        self.additionalInfoTextField.stringValue = buyer!.additionalInfo
    }
    
    @IBAction func onSaveButtonClickedAction(_ sender: Any) {
        let newBuyer = getBuyer()
        counterpartyFacade.replaceBuyer(buyer!, with: newBuyer)
        NotificationCenter.default.post(name: EditBuyerViewControllerConstants.BUYER_EDITED_NOTIFICATION, object: newBuyer)
        view.window?.close()
    }
}
