//
//  HomeBrewPackages.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.10.23.
//

import Foundation
import ComposableArchitecture

struct HomeBrewPackages: Reducer {
    struct State: Equatable {
        let id = UUID()
    }

    enum Action {
        case maintenanceButtonTapped(Bool)
        case incrementalPackagesUpdateTapped
        case packagesUpdateTapped
        case addTapTapped
        case installPackageTapped
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
