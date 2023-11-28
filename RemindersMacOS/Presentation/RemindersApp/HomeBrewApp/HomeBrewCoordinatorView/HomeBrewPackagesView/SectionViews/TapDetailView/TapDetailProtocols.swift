//
//  TapDetailProtocols.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Foundation
import Reminders_Domain

protocol TapDetailInteractorProtocol {
    func loadTapInfo(tapName: String, homeBrewTapInfo: LoadableSubject<BrewTapInfo>) -> Void
}

protocol TapDetailViewModelProtocol {
    var state: TapDetailViewModelState { get set }
    var brewTapName: String { get }
    func loadTapInfo() -> Void
}
