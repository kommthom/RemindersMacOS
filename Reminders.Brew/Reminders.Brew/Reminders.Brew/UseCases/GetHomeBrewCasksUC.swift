//
//  GetHomeBrewCasksUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetHomeBrewCasksUC: GetHomeBrewCasksUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(homeBrewCasks: LoadableSubject<[BrewPackage]>) {
        
        let cancelBag = CancelBag()
        homeBrewCasks.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] _ -> AnyPublisher<Bool, Error> in
                homeBrewShellRepository.hasLoadedHomeBrewCasks()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return Just<Void>.withErrorType(Error.self)
                }
            }
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.homeBrewCasks()
            }
            .sinkToLoadable {homeBrewCasks.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedGetHomeBrewCasksUC: GetHomeBrewCasksUCProtocol {
    public func execute(homeBrewCasks: LoadableSubject<[BrewPackage]>) -> Void {
        let cancelBag = CancelBag()
        homeBrewCasks.wrappedValue.setIsLoading(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}
