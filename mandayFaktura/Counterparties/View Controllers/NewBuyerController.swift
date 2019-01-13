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

class NewBuyerController: AbstractBuyerController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSaveButtonClickedAction(_ sender: Any) {
        let buyer = getBuyer()
        counterpartyInteractor.addBuyer(buyer: buyer)
        NotificationCenter.default.post(name: NewBuyerViewControllerConstants.BUYER_ADDED_NOTIFICATION, object: buyer)
        view.window?.close()
    }
}
