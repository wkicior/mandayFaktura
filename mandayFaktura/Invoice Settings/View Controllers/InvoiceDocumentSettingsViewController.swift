//
//  InvoiceDocumentSettingsViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 24.09.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class InvoiceDocumentSettingsViewController: NSViewController {
   
    @IBOutlet weak var paymentDateDays: NSTextField!
    @IBOutlet weak var paymentDateFrom: NSPopUpButton!
    @IBOutlet weak var defaultNotestTextField: NSTextField!
    @IBOutlet weak var mandayFakturaCredit: NSButton!
    @IBOutlet weak var defaultPrimaryLanguagePopUpButton: NSPopUpButton!
    @IBOutlet weak var defaultSecondLanguagePopUpButton: NSPopUpButton!
    
    let invoiceSettingsFacade = InvoiceSettingsFacade()
    
    @IBOutlet weak var helpText: NSTextField!
    
    @IBAction func onSelectPaymentDateFrom(_ sender: Any) {
        setHelpTextVisibility()
    }
    
    func setHelpTextVisibility() {
         self.helpText.isHidden = (paymentDateFrom.selectedItem?.tag == 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let invoiceSettings: InvoiceSettings? = self.invoiceSettingsFacade.getInvoiceSettings();
        self.paymentDateDays.stringValue = String(invoiceSettings?.paymentDateDays ?? 0)
        self.paymentDateFrom.selectItem(withTag: invoiceSettings?.paymentDateFrom.rawValue ?? 0)
        self.defaultNotestTextField.stringValue = invoiceSettings?.defaultNotes ?? ""
        self.mandayFakturaCredit.state = (invoiceSettings?.mandayFakturaCreditEnabled ?? true)
            ? NSControl.StateValue.on
            : NSControl.StateValue.off
        self.defaultPrimaryLanguagePopUpButton.selectItem(withTag: invoiceSettings?.primaryDefaultLanguage.index ?? Language.PL.index)
        self.defaultSecondLanguagePopUpButton.selectItem(withTag: invoiceSettings?.secondaryDefaultLanguage?.index ?? -1)
        setHelpTextVisibility()
    }
    @IBAction func onSave(_ sender: NSButton) {
        let paymentDateDays = Int(self.paymentDateDays.stringValue)!
        let paymentDateFrom = PaymentDateFrom(rawValue: self.paymentDateFrom.selectedItem?.tag ?? 0)!
        let primaryLanguage = Language.ofIndex(self.defaultPrimaryLanguagePopUpButton.selectedItem?.tag ?? Language.PL.index)!
        let secondaryLanguage = Language.ofIndex(self.defaultSecondLanguagePopUpButton.selectedItem?.tag ?? Language.PL.index)
        let invoiceSettings = InvoiceSettings(paymentDateDays: paymentDateDays, paymentDateFrom: paymentDateFrom, defaultNotes: defaultNotestTextField.stringValue,
            mandayFakturaCreditEnabled: self.mandayFakturaCredit.state == NSControl.StateValue.on,
            primaryDefaultLanguage: primaryLanguage,
            secondaryDefaultLanguage: secondaryLanguage)

        invoiceSettingsFacade.save(invoiceSettings)
        view.window?.close()
    }
    @IBAction func onCancel(_ sender: NSButton) {
         view.window?.close()
    }
}
