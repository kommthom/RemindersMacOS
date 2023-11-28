//
//  Setting.swift
//  Reminders.MyLists
//
//  Created by Thomas on 11.11.23.
//

import Foundation
import Reminders_Domain

extension Setting {
    public init?(managedObject: SettingsMO?) {
        self.init(id: managedObject?.id ?? UUID(), name: managedObject?.name ?? "", value: managedObject?.value ?? "")
    }
}
