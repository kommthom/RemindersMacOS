//
//  GitHubInteractorAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Foundation
import Swinject
import Reminders_Domain
import Reminders_GitHub

final class GitHubInteractorAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(GitHubRepositoriesInteractorProtocol.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return DefaultGitHubRepositoriesInteractor(
                logOutUseCase: useCaseProvider.logOutUC(),
                isAuthenticatedUseCase: useCaseProvider.isAuthenticatedUC(),
                getUserRepositoriesUseCase: useCaseProvider.getUserRepositoriesUC(),
                getActiveRepositoriesUseCase: useCaseProvider.getActiveRepositoriesUC(),
                getGitHubFilterCriteriaUseCase: useCaseProvider.getGitHubFilterCriteriaUC()
            )
        }
        container.register(RepositoryDetailInteractorProtocol.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return DefaultRepositoryDetailInteractor(
                setStarredUseCase: useCaseProvider.setStarredUC(),
                getRepositoryUseCase: useCaseProvider.getRepositoryUC(),
                createMyListItemIfNewUseCase: useCaseProvider.createMyListItemIfNewUC()
            )
        }
        container.register(LogInGitHubInteractorProtocol.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return DefaultLogInGitHubInteractor(
                logInUseCase: useCaseProvider.logInUC(),
                isAuthenticatedUseCase: useCaseProvider.isAuthenticatedUC()
            )
        }
    }
}


