//
//  InteractorAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Swinject

final class InteractorAssembly: Assembly {

    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            GitHubInteractorAssembly(),
            MyListsInteractorAssembly(),
            HomeBrewInteractorAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}
