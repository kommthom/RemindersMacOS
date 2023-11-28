//
//  GitHubRepositoriesInteractor.swift
//  RemindersMacOS
//
//  Created by Thomas on 21.11.23.
//

import Foundation
import Reminders_Domain

final class DefaultGitHubRepositoriesInteractor: GitHubRepositoriesInteractorProtocol {
    
    // MARK: Use Cases
    
    private let logOutUseCase: LogOutUCProtocol
    private let isAuthenticatedUseCase: IsAuthenticatedUCProtocol
    private let getUserRepositoriesUseCase: GetUserRepositoriesUCProtocol
    private let getActiveRepositoriesUseCase: GetActiveRepositoriesUCProtocol
    private let getGitHubFilterCriteriaUseCase: GetGitHubFilterCriteriaUCProtocol

    
    init(logOutUseCase: LogOutUCProtocol, isAuthenticatedUseCase: IsAuthenticatedUCProtocol, getUserRepositoriesUseCase: GetUserRepositoriesUCProtocol, getActiveRepositoriesUseCase: GetActiveRepositoriesUCProtocol, getGitHubFilterCriteriaUseCase: GetGitHubFilterCriteriaUCProtocol) {
        self.logOutUseCase = logOutUseCase
        self.isAuthenticatedUseCase = isAuthenticatedUseCase
        self.getUserRepositoriesUseCase = getUserRepositoriesUseCase
        self.getActiveRepositoriesUseCase = getActiveRepositoriesUseCase
        self.getGitHubFilterCriteriaUseCase = getGitHubFilterCriteriaUseCase
    }
    
    func loadUserRepositories(userName: UserName, userRepositories: LoadableSubject<UserRepositories>) {
        getUserRepositoriesUseCase
            .execute(userName: userName, userRepositories: userRepositories)
    }
    
    func loadActiveRepositories(gitHubFilterCriteria: GitHubFilterCriteria, activeRepositories: LoadableSubject<ActiveRepositories>) {
        getActiveRepositoriesUseCase
            .execute(filterCriteria: gitHubFilterCriteria, activeRepositories: activeRepositories)
    }
    
    func isGitHubAuthenticated() -> Bool {
        isAuthenticatedUseCase
            .execute()
    }
    
    func logOut() {
        logOutUseCase.execute()
    }
    
    func getGitHubFilterCriteria() -> GitHubFilterCriteria {
        getGitHubFilterCriteriaUseCase
            .execute()
    }
}

final class MockedGitHubRepositoriesInteractor: GitHubRepositoriesInteractorProtocol {
    func loadUserRepositories(userName: UserName, userRepositories: LoadableSubject<UserRepositories>) {
        
    }
    
    func loadActiveRepositories(gitHubFilterCriteria: GitHubFilterCriteria, activeRepositories: LoadableSubject<ActiveRepositories>) {
        
    }
    
    func isGitHubAuthenticated() -> Bool {
        false
    }
    
    func logOut() {
        
    }
    
    func getGitHubFilterCriteria() -> GitHubFilterCriteria {
        GitHubFilterCriteria()
    }
}
