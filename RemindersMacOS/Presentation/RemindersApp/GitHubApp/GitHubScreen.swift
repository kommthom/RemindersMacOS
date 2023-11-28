//
//  GitHubScreen.swift
//  RemindersMacOS
//
//  Created by Thomas on 03.10.23.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct GitHubScreen: Reducer {
    enum State: Equatable, Identifiable {
        case gitHub(GitHubUser.State)
        case editGitHubFilterCriteria(GitHubFilterCriteriaReducer.State)
        case logInToGitHub(LogInGitHub.State)
        
        var id: UUID {
            switch self {
            case .gitHub(let state):
                return state.id
            case .editGitHubFilterCriteria(let state):
                return state.id
            case .logInToGitHub(let state):
                return state.id
            }
        }
    }

    enum Action {
        case gitHub(GitHubUser.Action)
        case editGitHubFilterCriteria(GitHubFilterCriteriaReducer.Action)
        case logInToGitHub(LogInGitHub.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: /State.gitHub, action: /Action.gitHub) {
            GitHubUser()
        }
        Scope(state: /State.logInToGitHub, action: /Action.logInToGitHub) {
            LogInGitHub()
        }
        Scope(state: /State.editGitHubFilterCriteria, action: /Action.editGitHubFilterCriteria) {
            GitHubFilterCriteriaReducer()
        }
    }
}
