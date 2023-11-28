//
//  LogInGitHub.swift
//  RemindersMacOS
//
//  Created by Thomas on 08.10.23.
//

import Foundation
import ComposableArchitecture

struct LogInGitHub: Reducer {
    struct State: Equatable {
        let id = UUID()
    }

    enum Action {
        case goBackTapped
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
