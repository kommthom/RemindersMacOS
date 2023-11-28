//
//  GetHomeBrewFormulaeUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetHomeBrewFormulaeUC: GetHomeBrewFormulaeUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(homeBrewFormule: LoadableSubject<[BrewPackage]>) {
        
        let cancelBag = CancelBag()
        homeBrewFormule.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] _ -> AnyPublisher<Bool, Error> in
                homeBrewShellRepository.hasLoadedHomeBrewFormulae()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return Just<Void>.withErrorType(Error.self)
                }
            }
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.homeBrewFormulae()
            }
            .sinkToLoadable {homeBrewFormule.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedGetHomeBrewFormulaeUC: GetHomeBrewFormulaeUCProtocol {
    public func execute(homeBrewFormule: LoadableSubject<[BrewPackage]>) -> Void {
        let cancelBag = CancelBag()
        homeBrewFormule.wrappedValue.setIsLoading(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}

