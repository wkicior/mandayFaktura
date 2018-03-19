//
//  InvoiceNumberingSettingsViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 16.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class InvoiceNumberingSettingsViewController: NSViewController {
    @IBOutlet weak var separatorTextField: NSTextField!
    @IBOutlet weak var fixedPartTextField: NSTextField!
    @IBOutlet weak var dragOrderingDestination: DragOrderingDestination!
    let invoiceNumberingSettingsRepository: InvoiceNumberingSettingsRepository = InvoiceNumberingSettingsRepositoryFactory.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let numberingSettings = invoiceNumberingSettingsRepository.getInvoiceNumberingSettings()
        self.separatorTextField.stringValue = (numberingSettings?.separator) ?? ""
        self.fixedPartTextField.stringValue = (numberingSettings?.fixedPart) ?? ""
        dragOrderingDestination.delegate = self
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        let settings = InvoiceNumberingSettings(separator: separatorTextField.stringValue, fixedPart: fixedPartTextField.stringValue, templateOrderings: (invoiceNumberingSettingsRepository.getInvoiceNumberingSettings()?.templateOrderings)!)
        invoiceNumberingSettingsRepository.save(invoiceNumberingSettings: settings)
        view.window?.close()
    }
    @IBAction func onCancelButtonClicked(_ sender: NSButton) {
        view.window?.close()
    }
}

extension InvoiceNumberingSettingsViewController: DestinationViewDelegate {
    
    func processAction(_ action: String, center: NSPoint) {
        print(action)
    }
}

