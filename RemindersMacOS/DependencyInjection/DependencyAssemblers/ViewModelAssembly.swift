//
//  ViewModelAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.11.23.
//

import Swinject

final class ViewModelAssembly: Assembly {

    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            GitHubViewModelAssembly(),
            MyListsViewModelAssembly(),
            HomeBrewViewModelAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}
