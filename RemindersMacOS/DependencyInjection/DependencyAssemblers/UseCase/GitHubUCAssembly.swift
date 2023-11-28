//
//  GitHubUCAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.11.23.
//

import Swinject
import Reminders_Domain
import Reminders_GitHub

final class GitHubUCAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LogInUCProtocol.self) { resolver in
            guard let usersRepository = resolver.resolve(GitHubAPIProtocol.self) else {
                fatalError("LogInUCProtocol dependency could not be resolved")
            }
            return DefaultLogInUC(usersRepository: usersRepository)
        }.inObjectScope(.container)
        container.register(LogOutUCProtocol.self) { resolver in
            guard let usersRepository = resolver.resolve(GitHubAPIProtocol.self) else {
                fatalError("LogOutUCProtocol dependency could not be resolved")
            }
            return DefaultLogOutUC(usersRepository: usersRepository)
        }.inObjectScope(.container)
        container.register(IsAuthenticatedUCProtocol.self) { resolver in
            guard let usersRepository = resolver.resolve(GitHubAPIProtocol.self) else {
                fatalError("IsAuthenticatedUCProtocol dependency could not be resolved")
            }
            return DefaultIsAuthenticatedUC(usersRepository: usersRepository)
        }.inObjectScope(.container)
        container.register(GetActiveRepositoriesUCProtocol.self) { resolver in
            guard let usersRepository = resolver.resolve(GitHubAPIProtocol.self) else {
                fatalError("GetActiveRepositoriesUCProtocol dependency could not be resolved")
            }
            return DefaultGetActiveRepositoriesUC(usersRepository: usersRepository)
        }.inObjectScope(.container)
        container.register(GetUserRepositoriesUCProtocol.self) { resolver in
            guard let usersRepository = resolver.resolve(GitHubAPIProtocol.self) else {
                fatalError("GetUserRepositoriesUCProtocol dependency could not be resolved")
            }
            return DefaultGetUserRepositoriesUC(usersRepository: usersRepository)
        }.inObjectScope(.container)
        container.register(GetRepositoryUCProtocol.self) { resolver in
            guard let usersRepository = resolver.resolve(GitHubAPIProtocol.self) else {
                fatalError("GetRepositoryUCProtocol dependency could not be resolved")
            }
            return DefaultGetRepositoryUC(usersRepository: usersRepository)
        }.inObjectScope(.container)
        container.register(SetStarredUCProtocol.self) { resolver in
            guard let usersRepository = resolver.resolve(GitHubAPIProtocol.self) else {
                fatalError("SetStarredUCProtocol dependency could not be resolved")
            }
            return DefaultSetStarredUC(usersRepository: usersRepository)
        }.inObjectScope(.container)
        container.register(GetImageUCProtocol.self) { resolver in
            guard let repository = resolver.resolve(ImageWebRepositoryProtocol.self) else {
                fatalError("GetImageUCProtocol dependency could not be resolved")
            }
            return DefaultGetImageUC(repository: repository)
        }.inObjectScope(.container)
        container.register(UpdateGitHubFilterCriteriaUCProtocol.self) { resolver in
            guard let settingsRepository = resolver.resolve(SettingsDBRepositoryProtocol.self) else {
                fatalError("UpdateGitHubFilterCriteriaUCProtocol dependency could not be resolved")
            }
            return DefaultGUpdateGitHubFilterCriteriaUC(settingsRepository: settingsRepository)
        }.inObjectScope(.container)
        container.register(GetGitHubFilterCriteriaUCProtocol.self) { resolver in
            guard let settingsRepository = resolver.resolve(SettingsDBRepositoryProtocol.self) else {
                fatalError("GetGitHubFilterCriteriaUCProtocol dependency could not be resolved")
            }
            return DefaultGetGitHubFilterCriteriaUC(settingsRepository: settingsRepository)
        }.inObjectScope(.container)
    }
}

final class MockedGitHubUCAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LogInUCProtocol.self) { resolver in
            return MockedLogInUC()
        }.inObjectScope(.container)
        container.register(LogOutUCProtocol.self) { resolver in
            return MockedLogOutUC()
        }.inObjectScope(.container)
        container.register(IsAuthenticatedUCProtocol.self) { resolver in
            return MockedIsAuthenticatedUC()
        }.inObjectScope(.container)
        container.register(GetActiveRepositoriesUCProtocol.self) { resolver in
            return MockedGetActiveRepositoriesUC()
        }.inObjectScope(.container)
        container.register(GetUserRepositoriesUCProtocol.self) { resolver in
            return MockedGetUserRepositoriesUC()
        }.inObjectScope(.container)
        container.register(GetRepositoryUCProtocol.self) { resolver in
            return MockedGetRepositoryUC()
        }.inObjectScope(.container)
        container.register(SetStarredUCProtocol.self) { resolver in
            return MockedSetStarredUC()
        }.inObjectScope(.container)
        container.register(GetImageUCProtocol.self) { resolver in
            return MockedGetImageUC()
        }.inObjectScope(.container)
        container.register(UpdateGitHubFilterCriteriaUCProtocol.self) { resolver in
            return MockedUpdateGitHubFilterCriteriaUC()
        }.inObjectScope(.container)
        container.register(GetGitHubFilterCriteriaUCProtocol.self) { resolver in
            return MockedGetGitHubFilterCriteriaUC()
        }.inObjectScope(.container)
    }
}
