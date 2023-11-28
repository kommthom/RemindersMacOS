//
//  LogInRemindersCoordinator.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.09.23.
//

import ComposableArchitecture
import TCACoordinators
import SwiftUI

struct LogInRemindersCoordinator: Reducer {
  struct State: Equatable, IdentifiedRouterState {
    static let initialState = LogInRemindersCoordinator.State(
      routes: [.root(.welcome(.init()), embedInNavigationView: false)]
    )
    var routes: IdentifiedArrayOf<Route<LogInRemindersScreen.State>>
  }

  enum Action: IdentifiedRouterAction {
    case routeAction(LogInRemindersScreen.State.ID, action: LogInRemindersScreen.Action)
    case updateRoutes(IdentifiedArrayOf<Route<LogInRemindersScreen.State>>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .routeAction(_, .welcome(.logInTapped)):
          state.routes.presentSheet(.logInReminders(.init()))
      default:
        break
      }
      return .none
    }.forEachRoute {
      LogInRemindersScreen()
    }
  }
}
