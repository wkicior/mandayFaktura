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
    @IBOutlet weak var templateNumberLabel: NSTextField!
    let invoiceNumberingSettingsRepository: InvoiceNumberingSettingsRepository = InvoiceNumberingSettingsRepositoryFactory.instance
    
    var segments: [NumberingSegment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let numberingSettings = invoiceNumberingSettingsRepository.getInvoiceNumberingSettings()
        self.separatorTextField.stringValue = (numberingSettings?.separator) ?? ""
        dragOrderingDestination.delegate = self
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        // TODO strip segments from sample values
        let settings = InvoiceNumberingSettings(separator: separatorTextField.stringValue, segments: segments)
        invoiceNumberingSettingsRepository.save(invoiceNumberingSettings: settings)
        view.window?.close()
    }
    @IBAction func onCancelButtonClicked(_ sender: NSButton) {
        view.window?.close()
    }
}

extension InvoiceNumberingSettingsViewController: DestinationViewDelegate {
    func processAction(_ action: NumberingSegmentType, center: NSPoint) {
        let value = defaultValue(type: action)
        let segment = NumberingSegment(type: action, value: value)
        self.segments.append(segment)
        let numberingTemplate: NumberingCoder = NumberingSegmentCoder(delimeter: self.separatorTextField.stringValue, segmentTypes: [])
        
        templateNumberLabel.stringValue = numberingTemplate.encodeNumber(segments: segments)
    }
    
    func defaultValue(type: NumberingSegmentType) -> String {
        switch (type) {
        case .fixedPart:
            return self.fixedPartTextField.stringValue
        case .year:
            return "2018"
        case .incrementingNumber:
            return "1"
        }
    }
}

