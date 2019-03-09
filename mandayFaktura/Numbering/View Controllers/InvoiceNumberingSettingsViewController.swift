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
    let invoiceNumberingFacade = InvoiceNumberingFacade()
    @IBOutlet weak var separatorTextField: NSTextField!
    @IBOutlet weak var fixedPartTextField: NSTextField!
    @IBOutlet weak var dragOrderingDestination: DragOrderingDestination!
    @IBOutlet weak var templateNumberLabel: NSTextField!
    @IBOutlet weak var resetNumberOnYearChangeCheckbox: NSButton!
    var segments: [NumberingSegment] = []
    
    @IBAction func onSeparatorValueChange(_ sender: NSTextField) {
        showSampleInvoiceNumber()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let numberingSettings = invoiceNumberingFacade.getInvoiceNumberingSettings()
        self.separatorTextField.stringValue = (numberingSettings?.separator) ?? ""
        dragOrderingDestination.delegate = self
        self.segments = numberingSettings?.segments ?? []
        showSampleInvoiceNumber()
        setResetNumberOnYearChangeCheckboxAvailability()
        self.resetNumberOnYearChangeCheckbox.state = (numberingSettings?.resetOnYearChange ?? true) ? NSControl.StateValue.on : NSControl.StateValue.off
    }
    
    fileprivate func setResetNumberOnYearChangeCheckboxAvailability() {
        self.resetNumberOnYearChangeCheckbox.isEnabled = self.segments.filter({ s in s.type == .year}).count > 0
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        let settings = InvoiceNumberingSettings(separator: separatorTextField.stringValue, segments: segments, resetOnYearChange: self.resetNumberOnYearChangeCheckbox.state == NSControl.StateValue.on)
        invoiceNumberingFacade.save(invoiceNumberingSettings: settings)
        view.window?.close()
    }
    
    @IBAction func onCancelButtonClicked(_ sender: NSButton) {
        view.window?.close()
    }
    
    @IBAction func onClearSegmentsButtonClicked(_ sender: NSButton) {
        self.segments = []
        showSampleInvoiceNumber()
        setResetNumberOnYearChangeCheckboxAvailability()
    }
}

extension InvoiceNumberingSettingsViewController: DestinationViewDelegate {
    func processAction(_ action: NumberingSegmentType, center: NSPoint) {
        do {
            let value = try defaultValue(type: action)
            self.segments.append(NumberingSegment(type: action, value: action == .fixedPart ? value : nil))
            showSampleInvoiceNumber()
            setResetNumberOnYearChangeCheckboxAvailability()
        } catch InputValidationError.invalidNumber(let fieldName) {
            WarningAlert(warning: "\(fieldName) - błędny format ciągu znaków", text: "Zawartość pola musi być cyfrą lub literą.").runModal()
        } catch {
            //
        }
    }
    
    func showSampleInvoiceNumber() {
        let numberingTemplate: NumberingCoder = NumberingSegmentCoder(delimeter: self.separatorTextField.stringValue, segmentTypes: [])
        templateNumberLabel.stringValue = numberingTemplate.encodeNumber(segments: segmentsToDisplay)
    }
    
    var segmentsToDisplay: [NumberingSegmentValue] {
        get {
            return segments.map({s in s.type == .fixedPart ? NumberingSegmentValue(type: s.type, value: s.fixedValue!) :
                NumberingSegmentValue(type: s.type, value: try! defaultValue(type: s.type))})
        }
    }
    
    func defaultValue(type: NumberingSegmentType) throws -> String {
        switch (type) {
        case .fixedPart:
            try NumberingSegmentType.validateFixedPart(value: self.fixedPartTextField.stringValue)
            return self.fixedPartTextField.stringValue
        case .year:
            return String(Date().year)
        case .incrementingNumber:
            return "1"
        }
    }
}

