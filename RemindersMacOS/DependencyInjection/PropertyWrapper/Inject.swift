//
//  Inject.swift
//  RemindersMacOS
//
//  Created by Thomas on 21.09.23.
//

import Foundation
@propertyWrapper
struct Inject<Component> {
    let wrappedValue: Component
    init() {
        self.wrappedValue = DIContainer.shared.resolve()
    }
}
