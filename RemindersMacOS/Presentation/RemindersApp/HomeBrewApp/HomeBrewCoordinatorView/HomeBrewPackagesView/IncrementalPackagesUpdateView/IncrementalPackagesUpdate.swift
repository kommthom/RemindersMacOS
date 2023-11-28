//
//  IncrementalPackagesUpdate.swift
//  RemindersMacOS
//
//  Created by Thomas on 24.10.23.
//

import Foundation
import ComposableArchitecture

struct IncrementalPackagesUpdate: Reducer {
    struct State: Equatable {
        let id = UUID()
        //var outdatedPackages: Set<OutdatedPackage>
    }

    enum Action {
        case goBackTapped
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
