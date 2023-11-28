//
//  RepositoryAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.11.23.
//

import Swinject
import Reminders_Domain
import Reminders_Brew
import Reminders_GitHub
import Reminders_MyLists

final class RepositoryAssembly: Assembly {

    func assemble(container: Container) {
        container.register(GitHubAPIProtocol.self) { resolver in
            GitHubAPI
        }.inObjectScope(.container)
        container.register(ImageWebRepositoryProtocol.self) { resolver in
            ImageRepository
        }.inObjectScope(.container)
        container.register(MyListsDBRepositoryProtocol.self) { resolver in
            guard let dataSource = resolver.resolve(RemindersDataSourceProtocol.self) else {
                fatalError("MyListsDBRepositoryProtocol dependency could not be resolved")
            }
            return DefaultMyListsDBRepository(dataSource: dataSource)
        }.inObjectScope(.container)
        container.register(SettingsDBRepositoryProtocol.self) { resolver in
            guard let dataSource = resolver.resolve(RemindersDataSourceProtocol.self) else {
                fatalError("SettingsDBRepositoryProtocol dependency could not be resolved")
            }
            return DefaultSettingsDBRepository(dataSource: dataSource)
        }.inObjectScope(.container)
        container.register(HomeBrewShellRepositoryProtocol.self) { resolver in
            DefaultHomeBrewShellRepository()
        }.inObjectScope(.container)
        container.register(HomeBrewWebRepositoryProtocol.self) { resolver in
            DefaultHomeBrewWebRepository()
        }.inObjectScope(.container)
    }

}
