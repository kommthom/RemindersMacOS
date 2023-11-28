//
//  TopCasksViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import Foundation
import Reminders_Domain

class TopCasksViewModel: TopPackagesViewModel {
    
    // MARK: Use Cases
    
    private let getTopCasksUseCase: GetTopCasksUCProtocol
    
    init(getTopCasksUseCase: GetTopCasksUCProtocol) {
        self.getTopCasksUseCase = getTopCasksUseCase
    }
    
    override func load(numberOfDays: Int) {
        getTopCasksUseCase
            .execute(numberOfDays: numberOfDays, topPackages: loadableSubject(\.topPackages))
    }
}
