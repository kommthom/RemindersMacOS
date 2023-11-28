//
//  AddTapFinished.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.10.23.
//

import Foundation
import ComposableArchitecture

struct AddTapFinished: Reducer {
    struct State: Equatable {
        let id = UUID()
        var success: Bool
        var tapName: String
    }

    enum Action {
        case goBackTapped
        case goBackToRootTapped
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
