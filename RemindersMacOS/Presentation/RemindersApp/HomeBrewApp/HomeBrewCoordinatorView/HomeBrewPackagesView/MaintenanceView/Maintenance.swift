//
//  Maintenance.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.10.23.
//

import Foundation
import ComposableArchitecture

struct Maintenance: Reducer {
    struct State: Equatable {
        let id = UUID()
        var fastCacheDeletion: Bool
    }

    enum Action {
        case goBackTapped
        case maintenanceRunningButtonTapped(Bool, Bool, Bool, Bool)
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
