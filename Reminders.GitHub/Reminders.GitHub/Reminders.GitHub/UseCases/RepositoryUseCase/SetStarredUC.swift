//
//  SetStarredUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 20.09.23.
//

import Foundation
import Siesta
import Reminders_Domain

// MARK: - Implementation -

public class DefaultSetStarredUC: SetStarredUCProtocol {
    private let usersRepository: GitHubAPIProtocol
    
    public init(usersRepository: GitHubAPIProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func execute(loginRepositoryNameIsStarred: LoginRepositoryNameIsStarred, onCompletion: @escaping () -> Void) {
        executeOneArg(loginRepositoryNameIsStarred: loginRepositoryNameIsStarred) { _ in
            onCompletion()
        }
    }
    
    private func executeOneArg(loginRepositoryNameIsStarred: LoginRepositoryNameIsStarred, onCompletion: @escaping (_ responseInfo: ResponseInfo?) -> Void) {
        usersRepository
            .setStarred(loginRepositoryNameIsStarred)
            .onCompletion( onCompletion )
    }
}

public class MockedSetStarredUC: SetStarredUCProtocol {
    public func execute(loginRepositoryNameIsStarred: LoginRepositoryNameIsStarred, onCompletion: @escaping () -> Void) {

    }
    
    public init() {
    }
}
