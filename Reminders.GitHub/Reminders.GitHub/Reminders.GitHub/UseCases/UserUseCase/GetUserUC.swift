//
//  GetUserUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 18.09.23.
//

import Foundation
import Siesta
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetUserUC: GetUserUCProtocol {
    private let usersRepository: GitHubAPIProtocol
    
    public init(usersRepository: GitHubAPIProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func execute(_ username: String) -> Siesta.Resource? {
        usersRepository.user(username)
    }
    
}

public class MockedGetUserUC: GetUserUCProtocol {
    public func execute(_ username: String) -> Siesta.Resource? {
        return nil
    }
    
}
