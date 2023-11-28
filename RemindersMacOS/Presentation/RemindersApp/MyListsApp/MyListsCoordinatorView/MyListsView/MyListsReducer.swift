//
//  MyListsReducer.swift
//  RemindersMacOS
//
//  Created by Thomas on 03.10.23.
//

import Foundation
import TCACoordinators
import ComposableArchitecture
import Reminders_Domain

struct MyListsReducer: Reducer {
    struct State: Equatable {
        let id = UUID()
    }

    enum Action: Equatable {
        case gitHubButtonTapped(String)
        case logOutButtonTapped
        case addListButtonTapped
        case editListButtonTapped(MyList)
        case editListItemButtonTapped(MyListItem)
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

