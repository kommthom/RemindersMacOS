//
//  TopFormuleViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import Foundation
import Reminders_Domain

class TopFormulaeViewModel: TopPackagesViewModel {
    
    // MARK: Use Cases
    
    private let getTopFormulaeUseCase: GetTopFormulaeUCProtocol
    
    init(getTopFormulaeUseCase: GetTopFormulaeUCProtocol) {
        self.getTopFormulaeUseCase = getTopFormulaeUseCase
    }
    
    override func load(numberOfDays: Int) {
        getTopFormulaeUseCase
            .execute(numberOfDays: numberOfDays, topPackages: loadableSubject(\.topPackages))
    }
}
