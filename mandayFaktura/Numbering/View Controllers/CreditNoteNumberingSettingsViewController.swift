//
//  CreditNoteNumberingSettingsViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 09.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class CreditNoteNumberingSettingsViewController: DocumentNumberingSettingsViewController {
    let creditNoteNumberingFacade = CreditNoteNumberingFacade()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let numberingSettings = creditNoteNumberingFacade.getCreditNoteNumberingSettings()
        self.separatorTextField.stringValue = (numberingSettings?.separator) ?? ""
        dragOrderingDestination.delegate = self
        self.segments = numberingSettings?.segments ?? []
        showSampleDocumentNumber()
        setResetNumberOnYearChangeCheckboxAvailability()
        self.resetNumberOnYearChangeCheckbox.state = (numberingSettings?.resetOnYearChange ?? true) ? NSControl.StateValue.on : NSControl.StateValue.off
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        let settings = CreditNoteNumberingSettings(separator: separatorTextField.stringValue, segments: segments, resetOnYearChange: self.resetNumberOnYearChangeCheckbox.state == NSControl.StateValue.on)
        creditNoteNumberingFacade.save(creditNoteNumberingSettings: settings)
        view.window?.close()
    }
}

