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

    let invoiceRepository: InvoiceRepository = InMemoryInvoicesRepository()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        CounterpartyRepositoryFactory.register(repository: KeyedArchiverCounterpartyRepository())
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

