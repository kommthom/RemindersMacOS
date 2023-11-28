//
//  AreUpdatablePackagesAvailableUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.11.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultAreUpdatablePackagesAvailableUC: AreUpdatablePackagesAvailableUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(updateProgressTracker: UpdateProgressTracker, outdatedPackageTracker: OutdatedPackageTracker, success: ExecutableSubject<Bool>) {
        let cancelBag = CancelBag()
        success.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.updatablePackagesAvailable(updateProgressTracker, outdatedPackageTracker: outdatedPackageTracker)
            }
            .sinkToExecutable { success.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedAreUpdatablePackagesAvailableUC: AreUpdatablePackagesAvailableUCProtocol {
    public func execute(updateProgressTracker: UpdateProgressTracker, outdatedPackageTracker: OutdatedPackageTracker, success: ExecutableSubject<Bool>) {
    }
    
    public init() {
        
    }
}
