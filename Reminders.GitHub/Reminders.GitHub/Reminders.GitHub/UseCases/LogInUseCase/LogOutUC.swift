//
//  LogOutUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 18.09.23.
//

import Foundation
import Siesta
import Reminders_Domain

// MARK: - Implementation -

public class DefaultLogOutUC: LogOutUCProtocol {
    private let usersRepository: GitHubAPIProtocol
    
    public init(usersRepository: GitHubAPIProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func execute() -> Void {
        usersRepository.logOut()
    }
}

public class MockedLogOutUC: LogOutUCProtocol {
    public func execute() -> Void {
    }
    
    public init() {
    }
}
