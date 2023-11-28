//
//  GetCurrentUserStarredUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 20.09.23.
//

import Foundation
import Siesta
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetCurrentUserStarredUC: GetCurrentUserStarredUCProtocol {
    private let usersRepository: GitHubAPIProtocol
    
    public init(usersRepository: GitHubAPIProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func execute(_ repositoryModel: Repository) -> Siesta.Resource? {
        usersRepository.currentUserStarred(repositoryModel)
    }
    
}

public class MockedGetCurrentUserStarredUC: GetCurrentUserStarredUCProtocol {

    public func execute(_ repositoryModel: Repository) -> Siesta.Resource? {
        return nil
    }
    
}
