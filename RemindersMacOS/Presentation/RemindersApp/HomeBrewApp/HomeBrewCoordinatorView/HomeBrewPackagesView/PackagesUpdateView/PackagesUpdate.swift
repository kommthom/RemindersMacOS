//
//  PackagesUpdate.swift
//  RemindersMacOS
//
//  Created by Thomas on 23.10.23.
//

import Foundation
import ComposableArchitecture

struct PackagesUpdate: Reducer {
    struct State: Equatable {
        let id = UUID()
        //var outdatedPackages: Set<OutdatedPackage>
    }

    enum Action {
        case goBackTapped
        case goBackToRootTapped
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
