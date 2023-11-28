//
//  GitHubCoordinator.swift
//  RemindersMacOS
//
//  Created by Thomas on 03.10.23.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

struct GitHubCoordinator: Reducer {
    struct State: Equatable, IndexedRouterState {
        static let initialState = State(
            routes: [.root(.gitHub(.init()), embedInNavigationView: false)]
        )

        var routes: [Route<GitHubScreen.State>]
    }

    enum Action: IndexedRouterAction {
        case routeAction(Int, action: GitHubScreen.Action)
        case updateRoutes([Route<GitHubScreen.State>])
    }

    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .routeAction(_, .gitHub(.editGitHubFilterCriteriaButtonTapped(let gitHubFilterCriteria))):
                state.routes.presentSheet(.editGitHubFilterCriteria(.init(gitHubFilterCriteria: gitHubFilterCriteria)), embedInNavigationView: false)

            case .routeAction(_, .gitHub(.logInToGitHub)):
                state.routes.presentSheet(.logInToGitHub(.init()), embedInNavigationView: false)
                
            case .routeAction(_, .editGitHubFilterCriteria(.goBackTapped)):
                state.routes.goBack()

            case .routeAction(_, .logInToGitHub(.goBackTapped)):
                state.routes.goBack()

            default:
                break
            }
            return .none
        }

        .forEachRoute {
            GitHubScreen()
        }
    }
}
