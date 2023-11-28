//
//  TapDetailInteractor.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Foundation
import Reminders_Domain

final class TapDetailInteractor: TapDetailInteractorProtocol {
    
    // MARK: Use Cases
    
    private var getBrewTapInfoUseCase: GetBrewTapInfoUCProtocol
    
    init(getBrewTapInfoUseCase: GetBrewTapInfoUCProtocol) {
        self.getBrewTapInfoUseCase = getBrewTapInfoUseCase
    }  

    func loadTapInfo(tapName: String, homeBrewTapInfo: LoadableSubject<BrewTapInfo>) -> Void {
        getBrewTapInfoUseCase
            .execute( tapName: tapName, homeBrewTapInfo: homeBrewTapInfo)
    }
}
