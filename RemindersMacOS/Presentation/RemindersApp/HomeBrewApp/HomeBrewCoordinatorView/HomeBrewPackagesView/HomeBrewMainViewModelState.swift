//
//  HomeBrewMainViewModelState.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.11.23.
//

import Foundation
import Reminders_Domain

class HomeBrewMainViewModelState {

    @Published var availableTokens: [PackageSearchToken]
    @Published var currentTokens: [PackageSearchToken]
    @Published var searchText: String

    func suggestedTokens() -> [PackageSearchToken] {
        if searchText.starts(with: "#") {
            return availableTokens
        } else {
            return .init()
        }
    }
    
    init() {
        self.availableTokens = [
            PackageSearchToken(name: "search.token.filter-formulae", icon: "terminal", tokenSearchResultType: .formula),
            PackageSearchToken(name: "search.token.filter-casks", icon: "macwindow", tokenSearchResultType: .cask),
            PackageSearchToken(name: "search.token.filter-taps", icon: "spigot", tokenSearchResultType: .tap),
            PackageSearchToken(name: "search.token.filter-manually-installed-packages", icon: "hand.tap", tokenSearchResultType: .intentionallyInstalledPackage)
        ]
        self.currentTokens = .init()
        self.searchText = ""
    }
}
