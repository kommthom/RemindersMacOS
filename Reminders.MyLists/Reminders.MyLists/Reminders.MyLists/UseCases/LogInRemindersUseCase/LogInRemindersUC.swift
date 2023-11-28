//
//  LogInRemindersUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 05.10.23.
//

import Foundation
import Reminders_Domain

// MARK: - Implementation -

public class DefaultLogInRemindersUC: LogInRemindersUCProtocol {
    private let repository: SettingsDBRepositoryProtocol
    
    public init(repository: SettingsDBRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(username: String, password: String) -> Bool {
        repository.logInReminders(username: username, password: password)
    }
}

public class MockedLogInRemindersUC: LogInRemindersUCProtocol {
    public func execute(username: String, password: String) -> Bool {
        true
    }
    
    public init() {
        
    }
}
