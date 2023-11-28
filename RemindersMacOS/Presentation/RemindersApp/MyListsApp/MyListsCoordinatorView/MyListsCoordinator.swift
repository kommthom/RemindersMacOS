//
//  MyListsCoordinator.swift
//  RemindersMacOS
//
//  Created by Thomas on 03.10.23.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

struct MyListsCoordinator: Reducer {
    struct State: Equatable, IndexedRouterState {
        static func initialState() -> Self {
            Self(
                routes: [.root(.myLists(.init()), embedInNavigationView: false)]
            )
        }

        var routes: [Route<MyListsScreen.State>]
    }

    enum Action: IndexedRouterAction {
        case routeAction(Int, action: MyListsScreen.Action)
        case updateRoutes([Route<MyListsScreen.State>])
    }

    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .routeAction(_, .myLists(.addListButtonTapped)):
                state.routes.presentSheet(.addNewList(.init()), embedInNavigationView: false)

            case .routeAction(_, .myLists(.editListButtonTapped(let myList))):
                state.routes.presentSheet(.editList(.init(myList: myList)), embedInNavigationView: false)
                
            case .routeAction(_, .myLists(.editListItemButtonTapped(let myListItem))):
                state.routes.presentSheet(.editListItem(.init(myListItem: myListItem)), embedInNavigationView: false)

            case .routeAction(_, .addNewList(.goBackTapped)):
                state.routes.goBack()

            case .routeAction(_, .editList(.goBackTapped)):
                state.routes.goBack()
                
            case .routeAction(_, .editListItem(.goBackTapped)):
                state.routes.goBack()
                
            default:
                break
            }
            return .none
        }
        .forEachRoute {
            MyListsScreen()
        }
    }
}
