//
//  UseCaseAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.11.23.
//

import Swinject

final class UseCaseAssembly: Assembly {
    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            GitHubUCAssembly(),
            MyListsUCAssembly(),
            HomeBrewUCAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}

final class MockedUseCaseAssembly: Assembly {

    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            MockedGitHubUCAssembly(),
            MockedMyListsUCAssembly(),
            MockedHomeBrewUCAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}
