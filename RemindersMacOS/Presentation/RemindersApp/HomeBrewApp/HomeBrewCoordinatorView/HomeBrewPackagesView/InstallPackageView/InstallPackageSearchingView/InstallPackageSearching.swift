//
//  InstallPackageSearching.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import Foundation
import ComposableArchitecture

struct InstallPackageSearching: Reducer {
    struct State: Equatable {
        let id = UUID()
        var searchText: String
    }

    enum Action {
        case goBackTapped
        case startInstallationButtonTapped
        case goBackToRootTapped
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
