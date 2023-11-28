//
//  LogInRemindersViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 05.10.23.
//


import SwiftUI
import Reminders_Domain

class LogInRemindersViewModel: ObservableObject {
    
    private let logInUseCase: LogInRemindersUCProtocol
    
    private let userNameReminders = "userNameReminders"
    private let passwordReminders = "passwordReminders"
    
    @Published var credential: Credential
    @Published var error: LogInError?
    var isAuthenticated: Bool
    
    init(logInUseCase: LogInRemindersUCProtocol) {
        self.logInUseCase = logInUseCase
        self.isAuthenticated = false
        self.error = nil
        self.credential = Credential()
        do {
            let retrievedUserName = try KeychainWrapper.get(account: userNameReminders)
            self.credential.username = String(data: retrievedUserName!, encoding: .utf8)!
        } catch {
            // Handle Error
        }
        do {
            let retrievedPassword = try KeychainWrapper.get(account: passwordReminders)
            self.credential.password = String(data: retrievedPassword!, encoding: .utf8)!
        } catch {
            // Handle Error
        }
    }
    
    var loginDisabled: Bool {
        credential.username.isEmpty || credential.password.isEmpty
    }
    
    func performLogin() {
        isAuthenticated = logInUseCase.execute(username: credential.username, password: credential.password)
        if !isAuthenticated {
            error = LogInError.error(msg: "Authentication failed")
        } else {
            error = nil
        }
        if !credential.username.isEmpty && !credential.password.isEmpty {
            do {
                guard let username = credential.username.data(using: .utf8) else { return }
                try KeychainWrapper.set(value: username, account: userNameReminders)
            } catch {
                // Handle Error
            }
            do {
                guard let password = credential.password.data(using: .utf8) else { return }
                try KeychainWrapper.set(value: password, account: passwordReminders)
            } catch {
                // Handle Error
            }
        }
        //NotificationCenter.default.post(name: Constants.Notifications.authenticationChanged, object: true, userInfo: nil)
    }
}

