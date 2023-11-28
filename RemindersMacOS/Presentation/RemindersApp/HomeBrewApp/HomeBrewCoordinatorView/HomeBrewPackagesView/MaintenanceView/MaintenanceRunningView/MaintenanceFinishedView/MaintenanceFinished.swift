//
//  MaintenanceFinished.swift
//  RemindersMacOS
//
//  Created by Thomas on 25.10.23.
//

import Foundation
import ComposableArchitecture
import Reminders_Domain

struct MaintenanceFinished: Reducer {
    struct State: Equatable {
        let id = UUID()
        var maintenanceResultStates: MaintenanceResultStates
    }

    enum Action {
        case goBackTapped
        case goBackToRootTapped
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
