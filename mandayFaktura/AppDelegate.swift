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
    static let keyedArchiverProfile = "test"
    
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var removeInvoiceMenuItem: NSMenuItem!
    
    @IBAction func onRemoveInvoiceMenuItemClicked(_ sender: NSMenuItem) {
        NotificationCenter.default.post(name: ViewControllerConstants.INVOICE_TO_REMOVE_NOTIFICATION, object: nil)

    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menu.autoenablesItems = false
        self.removeInvoiceMenuItem.isEnabled = false
        
        
        NotificationCenter.default.addObserver(forName: ViewControllerConstants.INVOICE_SELECTED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.setRemoveInvoiceMenuItemAvailability(notification: notification)
                                                
                                           
        }
    }
    
    private func setRemoveInvoiceMenuItemAvailability(notification: Notification) {
        let dict = notification.userInfo as NSDictionary?
        let invoice = dict?[ViewControllerConstants.INVOICE_NOTIFICATION_KEY] as? Invoice
        self.removeInvoiceMenuItem.isEnabled = invoice != nil
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

