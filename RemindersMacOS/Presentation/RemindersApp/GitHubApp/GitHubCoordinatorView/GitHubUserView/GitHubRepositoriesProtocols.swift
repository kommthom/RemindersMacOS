//
//  GitHubRepositoriesProtocols.swift
//  RemindersMacOS
//
//  Created by Thomas on 21.11.23.
//

import Foundation
import Reminders_Domain

protocol GitHubRepositoriesInteractorProtocol {
    func loadUserRepositories(userName: UserName, userRepositories: LoadableSubject<UserRepositories>)
    func loadActiveRepositories(gitHubFilterCriteria: GitHubFilterCriteria, activeRepositories: LoadableSubject<ActiveRepositories>)
    func isGitHubAuthenticated() -> Bool
    func logOut()
    func getGitHubFilterCriteria() -> GitHubFilterCriteria
}

protocol GitHubRepositoriesViewModelProtocol {
    func logOut()
    func load()
    func loadUserRepositories()
    func loadActiveRepositories(_ gitHubFilterCriteria: GitHubFilterCriteria)
}
