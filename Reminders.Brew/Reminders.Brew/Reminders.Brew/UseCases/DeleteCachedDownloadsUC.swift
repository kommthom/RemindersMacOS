//
//  DeleteCachedDownloadsUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 26.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultDeleteCachedDownloadsUC: DeleteCachedDownloadsUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(reclaimedSpaceAfterCachePurge: ExecutableSubject<TypeOfResult>) -> Void {
        
        let cancelBag = CancelBag()
        reclaimedSpaceAfterCachePurge.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                return homeBrewShellRepository.deleteCachedDownloads()
            }
            .sinkToExecutable {reclaimedSpaceAfterCachePurge.wrappedValue = $0}
            .store(in: cancelBag)
    }

}

public class MockedDeleteCachedDownloadsUC: DeleteCachedDownloadsUCProtocol {
    public func execute(reclaimedSpaceAfterCachePurge: ExecutableSubject<TypeOfResult>) -> Void {
        let cancelBag = CancelBag()
        reclaimedSpaceAfterCachePurge.wrappedValue.setIsExecuting(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}
