//
//  ProviderAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.11.23.
//

import Swinject
import Reminders_Domain

final class ProviderAssembly: Assembly {

    func assemble(container: Container) {
        container.register(UseCaseProviderProtocol.self) { resolver in
            return DefaultUseCaseProvider()
        }
    }

}
