//
//  IsAuthenticatedUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 18.09.23.
//

import Foundation
import Siesta
import Reminders_Domain

// MARK: - Implementation -

public class DefaultIsAuthenticatedUC: IsAuthenticatedUCProtocol {
    private let usersRepository: GitHubAPIProtocol
    
    public init(usersRepository: GitHubAPIProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func execute() -> Bool {
        isNull(usersRepository.isAuthenticated, false)
    }
}

public class MockedIsAuthenticatedUC: IsAuthenticatedUCProtocol {
    public func execute() -> Bool {
        false
    }
    
    public init() {
    }
}
