//
//  TapDetailViewModelState.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.11.23.
//

import Foundation
import Reminders_Domain

class TapDetailViewModelState {
    
    private var brewTapInfo: BrewTapInfo? = nil
    
    // MARK: Observable Properties
    
    @Published var homeBrewTapInfo: Loadable<BrewTapInfo> = .notRequested {
        didSet {
            switch homeBrewTapInfo {
            case .loaded(let result):
                brewTapInfo = result
                availableCasks = brewTapInfo?.availableCasks
                availableFormulae = brewTapInfo?.availableFormulae
                homePage = brewTapInfo?.homePage
                isOfficial = brewTapInfo?.isOfficial
                numberOfPackages = brewTapInfo?.numberOfPackages
                AppLogger.homeBrew.log("BrewTap Loaded")
            case .notRequested:
                AppLogger.homeBrew.log("BrewTap Not Loaded")
            case .isLoading(_, _):
                AppLogger.homeBrew.log("BrewTap Loading")
            case .failed(let error):
                AppLogger.homeBrew.log(level: .error, "BrewTap Loading Error: \(error.localizedDescription)")
            }
        }
    }
    @Published var availableCasks: [String]?
    @Published var availableFormulae: [String]?
    @Published var homePage: URL?
    @Published var isOfficial: Bool?
    @Published var numberOfPackages: Int?
}
