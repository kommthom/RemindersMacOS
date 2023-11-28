//
//  UpdatePackagesUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.11.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultUpdatePackagesUC: UpdatePackagesUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(updateProgressTracker: UpdateProgressTracker, detailStage: UpdatingProcessDetails, success: ExecutableSubject<Bool>) {
        let cancelBag = CancelBag()
        success.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.updatePackages(updateProgressTracker: updateProgressTracker, detailStage: detailStage)
            }
            .sinkToExecutable { success.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedUpdatePackagesUC: UpdatePackagesUCProtocol {
    public func execute(updateProgressTracker: UpdateProgressTracker, detailStage: UpdatingProcessDetails, success: ExecutableSubject<Bool>) {
    }
    
    public init() {
        
    }
}
