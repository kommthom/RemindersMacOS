//
//  GetContributorsUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 18.09.23.
//

import Foundation
import Siesta
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetContributorsUC: GetContributorsUCProtocol {
    private let usersRepository: GitHubAPIProtocol
    
    public init(usersRepository: GitHubAPIProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func execute(resource: Resource?, url: String?) -> Resource? {
        usersRepository.optionalRelative(resource: resource, url: url)
    }
}

public class MockedGetContributorsUC: GetContributorsUCProtocol {

    public func execute(resource: Resource?, url: String?) -> Resource? {
        return nil
    }
}
