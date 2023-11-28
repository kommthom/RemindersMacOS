//
//  Welcome.swift
//  RemindersMacOS
//
//  Created by Thomas on 08.10.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct Welcome: Reducer {
  struct State: Equatable {
    let id = UUID()
  }

  enum Action {
    case logInTapped
  }

  var body: some ReducerOf<Self> {
    EmptyReducer()
  }
}
