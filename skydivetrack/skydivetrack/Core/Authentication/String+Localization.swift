//
//  String+Localization.swift
//  Skydivetrack
//
//  Created by Jabba on 10/1/25.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
