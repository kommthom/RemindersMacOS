//
//  InstallPackageReducer.swift
//  RemindersMacOS
//
//  Created by Thomas on 23.10.23.
//

import Foundation
import ComposableArchitecture

struct InstallPackageReducer: Reducer {
    struct State: Equatable {
        let id = UUID()
    }

    enum Action {
        case goBackTapped
        case startInstallationButtonTapped
        case startSearchingButtonTapped(searchText: String)
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
