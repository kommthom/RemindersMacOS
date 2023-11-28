//
//  TapDetailViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.10.23.
//

import Foundation
import SwiftUI
import Reminders_Domain

class TapDetailViewModel: ObservableObject, TapDetailViewModelProtocol {
    @Published var state: TapDetailViewModelState
    private let interactor: TapDetailInteractorProtocol
    let brewTapName: String
    
    init(brewTapName: String, interactor: TapDetailInteractorProtocol) {
        self.interactor = interactor
        self.brewTapName = brewTapName
        self.state = .init()
    }
    
    func loadTapInfo() -> Void {
        interactor
            .loadTapInfo(tapName: brewTapName, homeBrewTapInfo: loadableSubject(\.state.homeBrewTapInfo))
    }
}
