//
//  ToDoApp.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.10.23.
//

import TCACoordinators
import ComposableArchitecture

struct MyListsApp: Reducer {
    struct State: Equatable {
        static let initialState = State(logInReminders: .initialState, myLists: .initialState(), isLoggedIn: false)

        var logInReminders: LogInRemindersCoordinator.State
        var myLists: MyListsCoordinator.State
        var isLoggedIn: Bool
    }

    enum Action {
        case logInReminders(LogInRemindersCoordinator.Action)
        case myLists(MyListsCoordinator.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.logInReminders, action: /Action.logInReminders) {
            LogInRemindersCoordinator()
        }
        Scope(state: \.myLists, action: /Action.myLists) {
            MyListsCoordinator()
        }
        Reduce<State, Action> { state, action in
            switch action {
            case .logInReminders(.routeAction(_, .logInReminders(.loggedIn))):
                state.myLists = .initialState()
                state.isLoggedIn = true
            case .myLists(.routeAction(_, .myLists(.logOutButtonTapped))):
                state.logInReminders = .initialState
                state.isLoggedIn = false
            default:
                break
            }
            return .none
        }
    }
}
