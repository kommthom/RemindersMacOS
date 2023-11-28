//
//  AddTapRunning.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.10.23.
//

import Foundation
import ComposableArchitecture

struct AddTapRunning: Reducer {
    struct State: Equatable {
        let id = UUID()
        var tapName: String
    }

    enum Action {
        case goBackTapped
        case goBackToRootTapped
        case addTapFinishedButtonTapped(_ tapName: String, _ success: Bool)
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
