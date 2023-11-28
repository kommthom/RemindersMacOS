//
//  GitHubUserViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.09.23.
//

import Combine
import SwiftUI
import Reminders_Domain

class GitHubUserViewModel: ObservableObject, GitHubRepositoriesViewModelProtocol {
    private var interactor: GitHubRepositoriesInteractorProtocol
    private var user: User?
    
    @Published var repositories: [Repository]?
    @Published var searchText: String {
        didSet {
            if searchText != oldValue {
                load()
            }
        }
    }
    @Published var userRepositoriesLoadable: Loadable<UserRepositories> {
        didSet {
            switch userRepositoriesLoadable {
            case .notRequested:
                AppLogger.gitHub.log("User repositories not requested")
            case .isLoading(_, _):
                AppLogger.gitHub.log("User repositories is loading")
            case .failed(let error):
                AppLogger.gitHub.log("User repositories error: \(error.localizedDescription)")
            case .loaded(let userRepositories):
                if let user = userRepositories.user {
                    userFullName = user.name ?? "nobody"
                    userName = user.login
                    imageURL = URL(string: user.avatarURL)
                    AppLogger.gitHub.log("User repositories loaded: \(user.repositoriesURL)")
                }
                areRepositoriesLoaded = userRepositories.repositories.isLoaded
                if areRepositoriesLoaded {
                    repositories = userRepositories.repositories.currentValue
                    AppLogger.gitHub.log("User repositories loaded repositories: \(repositories?.count ?? 0)")
                } else {
                    AppLogger.gitHub.log("User repositories / repositories not loaded")
                }
            }
        }
    }
    @Published var activeRepositoriesLoadable: Loadable<ActiveRepositories> {
        didSet {
            switch activeRepositoriesLoadable {
            case .notRequested:
                AppLogger.gitHub.log("Active repositories not requested")
            case .isLoading(_, _):
                AppLogger.gitHub.log("Active repositories is loading")
            case .failed(let error):
                AppLogger.gitHub.log("Active repositories error: \(error.localizedDescription)")
            case .loaded(let activeRepositories):
                title = activeRepositories.title
                areRepositoriesLoaded = activeRepositories.repositories.isLoaded
                if areRepositoriesLoaded {
                    repositories = activeRepositories.repositories.currentValue
                    AppLogger.gitHub.log("Active repositories loaded repositories: \(repositories?.count ?? 0)")
                } else {
                    AppLogger.gitHub.log("Active repositories / repositories not loaded")
                }
            }
        }
    }
    @Published var isAuthenticated: Bool
    @Published var isUserHeader: Bool
    @Published var areRepositoriesLoaded: Bool
    @Published var userName: String
    @Published var title: String
    @Published var userFullName: String
    @Published var imageURL: URL?
    @Published var gitHubFilterCriteria: GitHubFilterCriteria {
        didSet {
            if gitHubFilterCriteria != oldValue {
                load()
            }
        }
    }

    init(interactor: GitHubRepositoriesInteractorProtocol) {
        self.interactor = interactor
        self.isAuthenticated = interactor.isGitHubAuthenticated()
        self.searchText = ""
        self.user = nil
        self.userName = ""
        self.title = ""
        self.userFullName = ""
        self.imageURL = nil
        self.areRepositoriesLoaded = false
        self.repositories = []
        self.gitHubFilterCriteria = interactor.getGitHubFilterCriteria()
        self.isUserHeader = false
        self.userRepositoriesLoadable = .notRequested
        self.activeRepositoriesLoadable = .notRequested
    }
    
    func logOut() {
        interactor.logOut()
        isAuthenticated = false
    }
    
    private func initView() {
        self.user = nil
        self.userName = ""
        self.title = ""
        self.userFullName = ""
        self.isUserHeader = !searchText.isEmpty
        self.imageURL = nil
        self.areRepositoriesLoaded = false
        self.repositories = []
        self.userRepositoriesLoadable = .notRequested
        self.activeRepositoriesLoadable = .notRequested
    }
    
    func load() {
        initView()
        if isUserHeader {
            loadUserRepositories()
        } else {
            loadActiveRepositories(gitHubFilterCriteria)
        }
    }
    
    func loadUserRepositories() {
        interactor
            .loadUserRepositories(userName: UserName(userName: searchText), userRepositories: loadableSubject(\.userRepositoriesLoadable))
    }
    
    func loadActiveRepositories(_ gitHubFilterCriteria: GitHubFilterCriteria) {
        self.gitHubFilterCriteria = gitHubFilterCriteria
        interactor
            .loadActiveRepositories(gitHubFilterCriteria: gitHubFilterCriteria, activeRepositories: loadableSubject(\.activeRepositoriesLoadable))
    }
}
