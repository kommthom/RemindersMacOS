//
//  MaintenanceRunning.swift
//  RemindersMacOS
//
//  Created by Thomas on 25.10.23.
//

import Foundation
import ComposableArchitecture
import Reminders_Domain

struct MaintenanceRunning: Reducer {
    struct State: Equatable {
        let id = UUID()
        var shouldUninstallOrphans: Bool
        var shouldPurgeCache: Bool
        var shouldDeleteDownloads: Bool
        var shouldPerformHealthCheck: Bool
    }

    enum Action {
        case goBackTapped
        case maintenanceFinishedButtonTapped(_ maintenanceResultStates: MaintenanceResultStates)
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
