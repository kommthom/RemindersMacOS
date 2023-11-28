//
//  LogInRemindersScreen.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.10.23.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct LogInRemindersScreen: Reducer {
  enum Action {
    case welcome(Welcome.Action)
    case logInReminders(LogInReminders.Action)
  }

  enum State: Equatable, Identifiable {
    case welcome(Welcome.State)
    case logInReminders(LogInReminders.State)

    var id: UUID {
      switch self {
      case .welcome(let state):
        return state.id
      case .logInReminders(let state):
        return state.id
      }
    }
  }

  var body: some ReducerOf<Self> {
    Scope(state: /State.welcome, action: /Action.welcome) {
      Welcome()
    }
    Scope(state: /State.logInReminders, action: /Action.logInReminders) {
      LogInReminders()
    }
  }
}
