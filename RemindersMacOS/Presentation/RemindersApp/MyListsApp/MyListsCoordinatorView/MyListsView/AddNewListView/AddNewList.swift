//
//  AddNewList.swift
//  RemindersMacOS
//
//  Created by Thomas on 06.10.23.
//

import Foundation
import ComposableArchitecture

struct AddNewList: Reducer {
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
