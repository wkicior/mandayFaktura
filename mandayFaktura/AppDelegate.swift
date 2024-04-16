//
//  AppDelegate.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.01.2018.
//  Licensed under the MIT License. See LICENSE file for more details
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    // keyed archiver name - change it for testing purposes
    static var keyedArchiverProfile: String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: "keyed_archiver_profile") as! String
        }
    }
    
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var removeInvoiceMenuItem: NSMenuItem!
    @IBOutlet weak var editInvoiceMenuItem: NSMenuItem!
    @IBOutlet weak var printInvoiceMenuItem: NSMenuItem!
    @IBOutlet weak var correctInvoiceMenuItem: NSMenuItem!
    @IBOutlet weak var ksefNumberMenuItem: NSMenuItem!
    
    @IBAction func onRemoveInvoiceMenuItemClicked(_ sender: NSMenuItem) {
        NotificationCenter.default.post(name: ViewControllerConstants.INVOICE_TO_REMOVE_NOTIFICATION, object: nil)
    }
    
    @IBAction func onCorrectInvoiceMenuItemClicked(_ sender: Any) {
        NotificationCenter.default.post(name: ViewControllerConstants.CREDIT_NOTE_NOTIFICATION, object: nil)
    }
    @IBAction func onEditInvoiceMenuItemClicked(_ sender: Any) {
        NotificationCenter.default.post(name: ViewControllerConstants.INVOICE_TO_EDIT_NOTIFICATION, object: nil)
    }
    
    @IBAction func onKsefNumberMenuItemClicked(_ sender: Any) {
        NotificationCenter.default.post(name: ViewControllerConstants.KSEF_NUMBER_NOTIFICATION, object: nil)
    }
    
    @IBAction func onPrintInvoiceMenuItemClicked(_ sender: NSMenuItem) {
        NotificationCenter.default.post(name: ViewControllerConstants.INVOICE_TO_PRINT_NOTIFICATION, object: nil)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menu.autoenablesItems = false
        self.removeInvoiceMenuItem.isEnabled = false
        self.correctInvoiceMenuItem.isEnabled = false
        self.printInvoiceMenuItem.isEnabled = false
        self.ksefNumberMenuItem.isEnabled = false
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.INVOICE_SELECTED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.setInvoiceMenuItemAvailability(notification: notification)
        }
    }
    
    private func setInvoiceMenuItemAvailability(notification: Notification) {
        let dict = notification.userInfo as NSDictionary?
        let invoice = dict?[ViewControllerConstants.INVOICE_NOTIFICATION_KEY] as? Invoice
        let creditNote = dict?[ViewControllerConstants.INVOICE_NOTIFICATION_KEY] as? CreditNote
        if (invoice != nil) {
            self.removeInvoiceMenuItem.isEnabled = true
            self.correctInvoiceMenuItem.isEnabled = true
            self.editInvoiceMenuItem.isEnabled = true
            self.printInvoiceMenuItem.isEnabled = true
            self.ksefNumberMenuItem.isEnabled = true
        } else if creditNote != nil {
            self.removeInvoiceMenuItem.isEnabled = true
            self.correctInvoiceMenuItem.isEnabled = false
            self.editInvoiceMenuItem.isEnabled = false
            self.printInvoiceMenuItem.isEnabled = true
            self.ksefNumberMenuItem.isEnabled = true
        } else {
            self.removeInvoiceMenuItem.isEnabled = false
            self.correctInvoiceMenuItem.isEnabled = false
            self.editInvoiceMenuItem.isEnabled = false
            self.printInvoiceMenuItem.isEnabled = false
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

