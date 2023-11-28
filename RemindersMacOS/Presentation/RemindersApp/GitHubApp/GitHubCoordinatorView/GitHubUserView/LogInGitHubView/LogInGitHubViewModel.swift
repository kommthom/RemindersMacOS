//
//  LogInGitHubViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.09.23.
//

import SwiftUI
import Reminders_Domain

class LogInGitHubViewModel: ObservableObject, LogInGitHubViewModelProtocol {
    private let interactor: LogInGitHubInteractorProtocol
    private let userNameGitHub = "userNameGitHub"
    private let passwordGitHub = "passwordGitHub"
    
    @Published var credential: Credential
    @Published var error: LogInError?
    var isAuthenticated: Bool {
        interactor.isAuthenticated
    }
   
    var loginDisabled: Bool {
        interactor.loginDisabled(credential: credential)
    }
    
    init(interactor: LogInGitHubInteractorProtocol) {
        self.interactor = interactor
        self.credential = Credential()
        do {
            let userNameData = try KeychainWrapper.get(account: userNameGitHub)
            self.credential.username = String(data: userNameData!, encoding: .utf8) ?? ""
            let passwordData = try KeychainWrapper.get(account: passwordGitHub)
            self.credential.password = String(data: passwordData!, encoding: .utf8) ?? ""
            self.error = nil
        } catch let error {
            self.error = LogInError.error(msg: "KeychainWrapper has error: \(error.localizedDescription)")
        }
    }
    
    func performLogin() {
        interactor.performLogin(credential: credential)
        if !credential.username.isEmpty && !credential.password.isEmpty {
            do {
                guard let username = credential.username.data(using: .utf8) else { return }
                try KeychainWrapper.set(value: username, account: userNameGitHub)
            } catch {
                // Handle Error
            }
            do {
                guard let password = credential.password.data(using: .utf8) else { return }
                try KeychainWrapper.set(value: password, account: passwordGitHub)
            } catch {
                // Handle Error
            }
        }
        //NotificationCenter.default.post(name: Constants.Notifications.authenticationChanged, object: true, userInfo: nil)
    }
}
