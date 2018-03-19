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
        print("process Action")
    }
    
    
}

protocol DestinationViewDelegate {
    func processAction(_ action: String, center: NSPoint)
}

class DragOrderingDestination: NSView {
    enum Appearance {
        static let lineWidth: CGFloat = 10.0
    }
    
    var delegate: DestinationViewDelegate?
    
    override func awakeFromNib() {
        setup()
    }
    
    let acceptableTypes: Set<NSPasteboard.PasteboardType> = [IncrementNumberDrag.type]
    
    func setup() {
        registerForDraggedTypes(Array(acceptableTypes))
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        if isReceivingDrag {
            NSColor.selectedControlColor.set()
            
            let path = NSBezierPath(rect:bounds)
            path.lineWidth = Appearance.lineWidth
            path.stroke()
        }
    }
    
    //we override hitTest so that this view which sits at the top of the view hierachy
    //appears transparent to mouse clicks
    override func hitTest(_ aPoint: NSPoint) -> NSView? {
        return nil
    }
    
    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        var canAccept = false
        let pasteBoard = draggingInfo.draggingPasteboard()
        if let types = pasteBoard.types, acceptableTypes.intersection(types).count > 0 {
            canAccept = true
        }
        return canAccept
    }
    
    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? .copy : NSDragOperation()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let allow = shouldAllowDrag(sender)
        return allow
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        let pasteBoard = draggingInfo.draggingPasteboard()
        let point = convert(draggingInfo.draggingLocation(), from: nil)
        if let types = pasteBoard.types, types.contains(IncrementNumberDrag.type),
            let action = pasteBoard.string(forType: IncrementNumberDrag.type) {
            delegate?.processAction(action, center:point)
            return true
        }
        return false
        
    }
}

extension NSView {
    /**
     Take a snapshot of a current state NSView and return an NSImage
     
     - returns: NSImage representation
     */
    func snapshot() -> NSImage {
        let pdfData = dataWithPDF(inside: bounds)
        let image = NSImage(data: pdfData)
        return image ?? NSImage()
    }
}

enum IncrementNumberDrag {
    static let type = NSPasteboard.PasteboardType(rawValue: "com.github.wkicior.mandayFaktura")
    static let action = "add increment"
}

class IncrementNumberSourceView: NSView {
    override func mouseDown(with theEvent: NSEvent) {
        
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setString(IncrementNumberDrag.action, forType: IncrementNumberDrag.type)
        let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        draggingItem.setDraggingFrame(self.bounds, contents: self.snapshot())
        
        beginDraggingSession(with: [draggingItem], event: theEvent, source: self)
        
    }
}

extension IncrementNumberSourceView: NSDraggingSource {
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor
        context: NSDraggingContext) -> NSDragOperation {
        
        switch(context) {
        case .outsideApplication:
            return NSDragOperation()
        case .withinApplication:
            return .generic
        }
    }
}
