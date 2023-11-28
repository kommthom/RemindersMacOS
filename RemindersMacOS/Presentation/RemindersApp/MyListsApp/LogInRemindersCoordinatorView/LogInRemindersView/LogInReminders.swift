//
//  LogInReminders.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.10.23.
//

import SwiftUI
import ComposableArchitecture

struct LogInReminders: Reducer {
  struct State: Equatable {
    let id = UUID()
  }

  enum Action {
    case loggedIn
  }

  var body: some ReducerOf<Self> {
    EmptyReducer()
  }
}
