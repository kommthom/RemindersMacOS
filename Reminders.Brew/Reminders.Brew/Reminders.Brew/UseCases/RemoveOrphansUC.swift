//
//  RemoveOrphansUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 26.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultRemoveOrphansUC: RemoveOrphansUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(numberOfOrphansRemoved: ExecutableSubject<TypeOfResult>) -> Void {
        
        let cancelBag = CancelBag()
        numberOfOrphansRemoved.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                return homeBrewShellRepository.removingOrphans()
            }
            .sinkToExecutable {numberOfOrphansRemoved.wrappedValue = $0}
            .store(in: cancelBag)
    }
}

public class MockedRemoveOrphansUC: RemoveOrphansUCProtocol {
    public func execute(numberOfOrphansRemoved: ExecutableSubject<TypeOfResult>) -> Void {
        let cancelBag = CancelBag()
        numberOfOrphansRemoved.wrappedValue.setIsExecuting(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}
