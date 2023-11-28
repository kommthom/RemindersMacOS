//
//  InstallPackageRunning.swift
//  RemindersMacOS
//
//  Created by Thomas on 31.10.23.
//

import Foundation
import ComposableArchitecture

struct InstallPackageRunning: Reducer {
    struct State: Equatable {
        let id = UUID()
    }

    enum Action {
        case goBackTapped
        case goBackToRootTapped
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
