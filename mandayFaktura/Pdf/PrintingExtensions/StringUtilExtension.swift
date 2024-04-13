//
//  StringUtilExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 13.01.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

public extension String {
    func linesCount() -> Int {
        return self.split(separator: "\u{2028}").count
    }
    
    func appendI10n(_ en: String, _ isInternational: Bool) -> String {
         return (isInternational ?  en + " | " : "") + self
    }
    
    func appendI10n(_ secondary: String) -> String {
         return self + " | " + secondary
    }
    
    internal func i18n(primaryLanguage: Language, secondaryLanguage: Language?, defaultContent : String) -> String {
        if #available(macOS 12, *) {
            guard let primaryBundlePath = Bundle.main.path(forResource: primaryLanguage.boundleCode, ofType: "lproj"), let primaryBundle = Bundle(path: primaryBundlePath)
            else {
                return defaultContent
            }
            let secondaryBundlePath = secondaryLanguage.map({ $0.boundleCode }).flatMap({ Bundle.main.path(forResource: $0, ofType: "lproj")})
            let secondaryBundle = secondaryBundlePath.map {Bundle(path: $0)}
            if (secondaryBundle == nil) {
                return String(localized: String.LocalizationValue(self), bundle: primaryBundle)
            } else {
                return String(localized: String.LocalizationValue(self), bundle: primaryBundle).appendI10n(String(localized: String.LocalizationValue(self), bundle: secondaryBundle!))
            }
        } else {
            return defaultContent
        }
    }
    
    internal func i18n(language: Language, defaultContent : String) -> String {
        if #available(macOS 12, *) {
            guard let primaryBundlePath = Bundle.main.path(forResource: language.boundleCode, ofType: "lproj"), let primaryBundle = Bundle(path: primaryBundlePath)
            else {
                return defaultContent
            }
            return String(localized: String.LocalizationValue(self), bundle: primaryBundle)
        } else {
            return defaultContent
        }
    }
}
