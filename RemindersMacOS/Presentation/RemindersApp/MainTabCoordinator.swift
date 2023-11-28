//
//  AppCoordinator.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.09.23.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct MainTabCoordinator: Reducer {
    
    enum Tab: Hashable {
        case app
        case gitHub
        case homeBrew
    }

    enum Action {
        case homeBrew(HomeBrewCoordinator.Action)
        case app(MyListsApp.Action)
        case gitHub(GitHubCoordinator.Action)
        case tabSelected(Tab)
    }

    struct State: Equatable {
        static let initialState = State(
            homeBrew: .initialState,
            app: .initialState,
            gitHub: .initialState,
            selectedTab: .app
        )

        var homeBrew: HomeBrewCoordinator.State
        var app: MyListsApp.State
        var gitHub: GitHubCoordinator.State

        var selectedTab: Tab
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.homeBrew, action: /Action.homeBrew) {
            HomeBrewCoordinator()
        }
        Scope(state: \.app, action: /Action.app) {
            MyListsApp()
        }
        Scope(state: \.gitHub, action: /Action.gitHub) {
            GitHubCoordinator()
        }
        Reduce { state, action in
            switch action {
            case .tabSelected(let tab):
                state.selectedTab = tab
            default:
                break
            }
            return .none
        }
    }
}
