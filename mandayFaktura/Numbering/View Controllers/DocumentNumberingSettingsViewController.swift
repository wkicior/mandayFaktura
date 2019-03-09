//
//  DocumentNumberingSettingsViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 09.03.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class DocumentNumberingSettingsViewController: NSViewController {
    @IBOutlet weak var separatorTextField: NSTextField!
    @IBOutlet weak var fixedPartTextField: NSTextField!
    @IBOutlet weak var dragOrderingDestination: DragOrderingDestination!
    @IBOutlet weak var templateNumberLabel: NSTextField!
    @IBOutlet weak var resetNumberOnYearChangeCheckbox: NSButton!
    var segments: [NumberingSegment] = []
    
    @IBAction func onSeparatorValueChange(_ sender: NSTextField) {
        showSampleDocumentNumber()
    }
    
    func setResetNumberOnYearChangeCheckboxAvailability() {
        self.resetNumberOnYearChangeCheckbox.isEnabled = self.segments.filter({ s in s.type == .year}).count > 0
    }
    
    @IBAction func onCancelButtonClicked(_ sender: NSButton) {
        view.window?.close()
    }
    
    @IBAction func onClearSegmentsButtonClicked(_ sender: NSButton) {
        self.segments = []
        showSampleDocumentNumber()
        setResetNumberOnYearChangeCheckboxAvailability()
    }
}

extension DocumentNumberingSettingsViewController: DestinationViewDelegate {
    func processAction(_ action: NumberingSegmentType, center: NSPoint) {
        do {
            let value = try defaultValue(type: action)
            self.segments.append(NumberingSegment(type: action, value: action == .fixedPart ? value : nil))
            showSampleDocumentNumber()
            setResetNumberOnYearChangeCheckboxAvailability()
        } catch InputValidationError.invalidNumber(let fieldName) {
            WarningAlert(warning: "\(fieldName) - błędny format ciągu znaków", text: "Zawartość pola musi być cyfrą lub literą.").runModal()
        } catch {
            //
        }
    }
    
    func showSampleDocumentNumber() {
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

