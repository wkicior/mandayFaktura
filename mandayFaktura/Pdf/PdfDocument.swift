//
//  PdfDocument.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 24.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz

extension String {
    var encodeToFilename: String {
        get {
            return self.replacingOccurrences(of: "/", with: "-")
        }
    }
}

enum CopyTemplate: String {
    case original = "oryginał", copy = "kopia"
}

protocol PdfDocument {
    func getDocument() -> PDFDocument
    func save(dir: URL)
}
