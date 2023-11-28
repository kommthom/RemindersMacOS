//
//  logInUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 18.09.23.
//

import Foundation
import Siesta
import Reminders_Domain

// MARK: - Implementation -

public class DefaultLogInUC: LogInUCProtocol {
    private let usersRepository: GitHubAPIProtocol
    
    public init(usersRepository: GitHubAPIProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func execute(username: String, password: String) -> Void {
        usersRepository.logIn(username: username, password: password)
    }
}

public class MockedLogInUC: LogInUCProtocol {
    public func execute(username: String, password: String) -> Void {
    }
    
    public init() {
    }
}
