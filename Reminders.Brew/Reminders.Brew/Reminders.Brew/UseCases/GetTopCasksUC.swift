//
//  GetTopCasksUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetTopCasksUC: GetTopCasksUCProtocol {
    private let homeBrewWebRepository: HomeBrewWebRepositoryProtocol
    
    public init(homeBrewWebRepository: HomeBrewWebRepositoryProtocol) {
        self.homeBrewWebRepository = homeBrewWebRepository
    }
    
    public func execute(numberOfDays: Int, topPackages: LoadableSubject<[TopPackage]>) -> Void {
        
        let cancelBag = CancelBag()
        topPackages.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewWebRepository] in
                homeBrewWebRepository.topPackages(isCask: true, numberOfDays: numberOfDays)
            }
            .sinkToLoadable {topPackages.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedGetTopCasksUC: GetTopCasksUCProtocol {
    public func execute(numberOfDays: Int, topPackages: LoadableSubject<[TopPackage]>) -> Void {
        let cancelBag = CancelBag()
        topPackages.wrappedValue.setIsLoading(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}
