//
//  GetHomeBrewAddedTapsUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetHomeBrewTapsUC: GetHomeBrewTapsUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(homeBrewTaps: LoadableSubject<[BrewTap]>) {
        let cancelBag = CancelBag()
        homeBrewTaps.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] _ -> AnyPublisher<Bool, Error> in
                homeBrewShellRepository.hasLoadedHomeBrewTaps()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return Just<Void>.withErrorType(Error.self)
                }
            }
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.homeBrewTaps()
            }
            .sinkToLoadable {homeBrewTaps.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedGetHomeBrewTapsUC: GetHomeBrewTapsUCProtocol {
    public func execute(homeBrewTaps: LoadableSubject<[BrewTap]>) -> Void {
        let cancelBag = CancelBag()
        homeBrewTaps.wrappedValue.setIsLoading(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}
