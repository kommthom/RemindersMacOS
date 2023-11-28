//
//  LogInGitHubInteractor.swift
//  RemindersMacOS
//
//  Created by Thomas on 24.11.23.
//

import Foundation
import Reminders_Domain

final class DefaultLogInGitHubInteractor: LogInGitHubInteractorProtocol {
    
    // MARK: Use Cases
    
    private let logInUseCase: LogInUCProtocol
    private let isAuthenticatedUseCase: IsAuthenticatedUCProtocol
    
    init(logInUseCase: LogInUCProtocol, isAuthenticatedUseCase: IsAuthenticatedUCProtocol) {
        self.logInUseCase = logInUseCase
        self.isAuthenticatedUseCase = isAuthenticatedUseCase
    }
    var isAuthenticated: Bool {
        isAuthenticatedUseCase.execute()
    }
    
    func loginDisabled(credential: Credential) -> Bool {
        credential.username.isEmpty || credential.password.isEmpty
    }
    
    func performLogin(credential: Credential) {
        logInUseCase.execute(username: credential.username, password: credential.password)
    }
}

final class MockedRLogInGitHubInteractor: LogInGitHubInteractorProtocol {
    var isAuthenticated: Bool
    
    func loginDisabled(credential: Credential) -> Bool {
        false
    }
    
    func performLogin(credential: Credential) {
    }
    
    init() {
        self.isAuthenticated = false
    }
}
