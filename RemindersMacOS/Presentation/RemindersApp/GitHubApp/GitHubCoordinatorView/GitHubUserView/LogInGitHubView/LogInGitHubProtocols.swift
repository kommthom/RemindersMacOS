//
//  LogInGitHubProtocols.swift
//  RemindersMacOS
//
//  Created by Thomas on 24.11.23.
//

import Foundation
import Reminders_Domain

protocol LogInGitHubInteractorProtocol {
    var isAuthenticated: Bool { get }
    func loginDisabled(credential: Credential) -> Bool
    func performLogin(credential: Credential)
}

protocol LogInGitHubViewModelProtocol {
    var isAuthenticated: Bool { get }
    var loginDisabled: Bool { get }
    func performLogin()
}
