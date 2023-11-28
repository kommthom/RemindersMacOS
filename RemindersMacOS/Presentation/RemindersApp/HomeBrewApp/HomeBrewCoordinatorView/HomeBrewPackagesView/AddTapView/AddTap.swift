//
//  AddTap.swift
//  RemindersMacOS
//
//  Created by Thomas on 23.10.23.
//

import Foundation
import ComposableArchitecture

struct AddTap: Reducer {
    struct State: Equatable {
        let id = UUID()
    }

    enum Action {
        case goBackTapped
        case addTapRunningButtonTapped(_ tapName: String)
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
