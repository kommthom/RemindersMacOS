//
//  EditListItem.swift
//  RemindersMacOS
//
//  Created by Thomas on 06.10.23.
//

import Foundation
import ComposableArchitecture
import Reminders_Domain

struct EditListItem: Reducer {
    struct State: Equatable {
        let id = UUID()
        var myListItem: MyListItem
    }

    enum Action {
        case goBackTapped
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
