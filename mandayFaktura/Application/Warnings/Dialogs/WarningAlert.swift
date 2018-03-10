//
//  WarningAlert.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 05.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa

class WarningAlert: NSAlert {
    init(warning: String, text: String) {
        super.init()
        self.messageText = warning
        self.informativeText = text
        self.alertStyle = .warning
        self.addButton(withTitle: "OK")
    }
}
