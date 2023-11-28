//
//  GitHubFilterCriteriaReducer.swift
//  RemindersMacOS
//
//  Created by Thomas on 08.10.23.
//

import Foundation
import ComposableArchitecture
import Reminders_Domain

struct GitHubFilterCriteriaReducer: Reducer {
    struct State: Equatable {
        let id = UUID()
        var gitHubFilterCriteria: GitHubFilterCriteria
    }

    enum Action {
        case goBackTapped
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
