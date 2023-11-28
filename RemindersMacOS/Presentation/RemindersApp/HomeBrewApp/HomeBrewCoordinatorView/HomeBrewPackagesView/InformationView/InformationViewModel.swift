//
//  InformationViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 22.10.23.
//

import Foundation
import Reminders_Domain

class InformationViewModel: ObservableObject {
    private let getOutdatedPackagesUseCase: GetOutdatedPackagesUCProtocol
    
    @Published var outdatedPackages: Loadable<Set<OutdatedPackage>> = .notRequested
    
    init(getOutdatedPackagesUseCase: GetOutdatedPackagesUCProtocol) {
        self.getOutdatedPackagesUseCase = getOutdatedPackagesUseCase
    }
    
    @MainActor 
    func load(brewData: BrewDataStorage) -> Void {
        getOutdatedPackagesUseCase
            .execute(brewData: brewData, outdatedPackages: loadableSubject(\.outdatedPackages))
    }
}
