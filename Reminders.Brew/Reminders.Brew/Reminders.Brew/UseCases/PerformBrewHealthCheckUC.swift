//
//  PerformBrewHealthCheckUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 26.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultPerformBrewHealthCheckUC: PerformBrewHealthCheckUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(brewHealthCheckFoundNoProblems: ExecutableSubject<TypeOfResult>) -> Void {
        
        let cancelBag = CancelBag()
        brewHealthCheckFoundNoProblems.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                return homeBrewShellRepository.performBrewHealthCheck()
            }
            .sinkToExecutable {brewHealthCheckFoundNoProblems.wrappedValue = $0}
            .store(in: cancelBag)
    }
}

public class MockedPerformBrewHealthCheckUC: PerformBrewHealthCheckUCProtocol {
    public func execute(brewHealthCheckFoundNoProblems: ExecutableSubject<TypeOfResult>) -> Void {
        let cancelBag = CancelBag()
        brewHealthCheckFoundNoProblems.wrappedValue.setIsExecuting(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}
