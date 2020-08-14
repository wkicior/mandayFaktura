//
//  BuyerView.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 17.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

struct BuyerViewControllerConstants {
    static let BUYER_SELECTED_NOTIFICATION = Notification.Name(rawValue: "BuyerSelected")
}


class BuyerViewController : NSViewController {
    let counterpartyFacade = CounterpartyFacade()
    var buyer: Counterparty?

    @IBOutlet weak var viewSellersPopUpButton: NSPopUpButton!
    @IBOutlet weak var buyerNameTextField: NSTextField!
    @IBOutlet weak var streetAndNumberTextField: NSTextField!
    @IBOutlet weak var postalCodeTextField: NSTextField!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var taxCodeTextField: NSTextField!
    @IBOutlet weak var additionalInfoTextField: NSTextField!
    @IBOutlet weak var countryTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.counterpartyFacade.getBuyers().forEach{buyer in viewSellersPopUpButton.addItem(withTitle: buyer.name)}
        self.buyerNameTextField.stringValue = buyer?.name ?? ""
        self.streetAndNumberTextField.stringValue = buyer?.streetAndNumber ?? ""
        self.postalCodeTextField.stringValue = buyer?.postalCode ?? ""
        self.cityTextField.stringValue = buyer?.city ?? ""
        self.taxCodeTextField.stringValue = buyer?.taxCode ?? ""
        self.cityTextField.stringValue = buyer?.city ?? ""
        self.additionalInfoTextField.stringValue = buyer?.additionalInfo ?? ""
        self.countryTextField.stringValue = buyer?.country ?? ""
    }
    
    @IBAction func onSelectBuyer(_ sender: NSPopUpButton) {
        let buyerName = sender.selectedItem?.title
        let buyer = self.counterpartyFacade.getBuyer(name: buyerName!)
        setBuyer(buyer: buyer ?? aCounterparty().build())
        NotificationCenter.default.post(name: BuyerViewControllerConstants.BUYER_SELECTED_NOTIFICATION, object: buyer)
    }
    
    private func setBuyer(buyer: Counterparty) {
        self.buyerNameTextField.stringValue = buyer.name
        self.streetAndNumberTextField.stringValue = buyer.streetAndNumber
        self.cityTextField.stringValue = buyer.city
        self.postalCodeTextField.stringValue = buyer.postalCode
        self.taxCodeTextField.stringValue = buyer.taxCode
        self.additionalInfoTextField.stringValue = buyer.additionalInfo
        self.countryTextField.stringValue = buyer.country
    }
    
    func getBuyer() -> Counterparty {
        return CounterpartyBuilder()
            .withName(buyerNameTextField.stringValue)
            .withStreetAndNumber(streetAndNumberTextField.stringValue)
            .withCity(cityTextField.stringValue)
            .withPostalCode(postalCodeTextField.stringValue)
            .withTaxCode(taxCodeTextField.stringValue)
            .withAdditionalInfo(additionalInfoTextField.stringValue)
            .withCountry(countryTextField.stringValue)
            .build()
    }
    
    func isValid() -> Bool {
        return !self.buyerNameTextField.stringValue.isEmpty
            && !self.streetAndNumberTextField.stringValue.isEmpty
            && !self.postalCodeTextField.stringValue.isEmpty
            && !self.taxCodeTextField.stringValue.isEmpty
            && !self.cityTextField.stringValue.isEmpty
    }
}
