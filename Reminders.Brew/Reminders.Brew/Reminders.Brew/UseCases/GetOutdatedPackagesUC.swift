//
//  GetOutdatedPackagesUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 22.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetOutdatedPackagesUC: GetOutdatedPackagesUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(brewData: BrewDataStorage, outdatedPackages: LoadableSubject<Set<OutdatedPackage>>) {
        
        let cancelBag = CancelBag()
        outdatedPackages.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.outdatedPackages(brewData: brewData)
            }
            .sinkToLoadable {outdatedPackages.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedGetOutdatedPackagesUC: GetOutdatedPackagesUCProtocol {
    public func execute(brewData: BrewDataStorage, outdatedPackages: LoadableSubject<Set<OutdatedPackage>>) -> Void {
        let cancelBag = CancelBag()
        outdatedPackages.wrappedValue.setIsLoading(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}

