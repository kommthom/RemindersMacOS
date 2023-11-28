//
//  GitHubViewModelAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Foundation
import Swinject
import Reminders_Domain
import Reminders_GitHub

final class GitHubViewModelAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LogInGitHubViewModel.self) { resolver in
            guard let interactor = resolver.resolve(LogInGitHubInteractorProtocol.self) else {
                fatalError("LogInGitHubInteractorProtocol dependency could not be resolved")
            }
            return LogInGitHubViewModel(
                interactor: interactor
            )
        }
        container.register(GitHubUserViewModel.self) { resolver in
            guard let interactor = resolver.resolve(GitHubRepositoriesInteractorProtocol.self) else {
                fatalError("GitHubRepositoriesInteractorProtocol dependency could not be resolved")
            }
            return GitHubUserViewModel(
                interactor: interactor
            )
        }
        container.register(RepositoryDetailsViewModel.self) { (resolver, loginRepositoryName: LoginRepositoryName)  in
            guard let interactor = resolver.resolve(RepositoryDetailInteractorProtocol.self) else {
                fatalError("RepositoryDetailInteractorProtocol dependency could not be resolved")
            }
            return RepositoryDetailsViewModel(
                interactor: interactor,
                loginRepositoryName: loginRepositoryName
            )
        }
    }
}
