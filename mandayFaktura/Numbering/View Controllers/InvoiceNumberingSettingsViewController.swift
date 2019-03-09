//
//  InvoiceNumberingSettingsViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 16.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class InvoiceNumberingSettingsViewController: DocumentNumberingSettingsViewController {
    let invoiceNumberingFacade = InvoiceNumberingFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let numberingSettings = invoiceNumberingFacade.getInvoiceNumberingSettings()
        self.separatorTextField.stringValue = (numberingSettings?.separator) ?? ""
        dragOrderingDestination.delegate = self
        self.segments = numberingSettings?.segments ?? []
        showSampleDocumentNumber()
        setResetNumberOnYearChangeCheckboxAvailability()
        self.resetNumberOnYearChangeCheckbox.state = (numberingSettings?.resetOnYearChange ?? true) ? NSControl.StateValue.on : NSControl.StateValue.off
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        let settings = InvoiceNumberingSettings(separator: separatorTextField.stringValue, segments: segments, resetOnYearChange: self.resetNumberOnYearChangeCheckbox.state == NSControl.StateValue.on)
        invoiceNumberingFacade.save(invoiceNumberingSettings: settings)
        view.window?.close()
    }
}
