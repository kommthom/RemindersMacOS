//
//  PurgeHomebrewCacheUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 26.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultPurgeHomebrewCacheUC: PurgeHomebrewCacheUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(packagesHoldingBackCachePurge: ExecutableSubject<TypeOfResult>) -> Void {
        
        let cancelBag = CancelBag()
        packagesHoldingBackCachePurge.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                return homeBrewShellRepository.purgeHomebrewCache()
            }
            .sinkToExecutable {packagesHoldingBackCachePurge.wrappedValue = $0}
            .store(in: cancelBag)
    }

}

public class MockedPurgeHomebrewCacheUC: PurgeHomebrewCacheUCProtocol {
    public func execute(packagesHoldingBackCachePurge: ExecutableSubject<TypeOfResult>) -> Void {
        let cancelBag = CancelBag()
        packagesHoldingBackCachePurge.wrappedValue.setIsExecuting(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}
