//
//  String.localized.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.11.23.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
