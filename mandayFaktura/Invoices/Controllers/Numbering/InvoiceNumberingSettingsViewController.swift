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
        self.segments = numberingSettings?.segments ?? []
        showSampleInvoiceNumber()
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
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
        self.segments.append(NumberingSegment(type: action, value: action == .fixedPart ? value : nil))
        showSampleInvoiceNumber()
    }
    
    func showSampleInvoiceNumber() {
        let numberingTemplate: NumberingCoder = NumberingSegmentCoder(delimeter: self.separatorTextField.stringValue, segmentTypes: [])
        
        templateNumberLabel.stringValue = numberingTemplate.encodeNumber(segments: segmentsToDisplay)
    }
    
    var segmentsToDisplay: [NumberingSegment] {
        get {
            return segments.map({s in s.type == .fixedPart ? s : NumberingSegment(type: s.type, value: defaultValue(type: s.type))})
        }
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

