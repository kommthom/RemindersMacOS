//
//  GetSearchedPackagesUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 31.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetSearchedPackagesUC: GetSearchedPackagesUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(packageName: String, isCask: Bool, searchPackages: LoadableSubject<[String]>) -> Void {
        
        let cancelBag = CancelBag()
        searchPackages.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.searchPackages(packageName: packageName, isCask: true)
            }
            .sinkToLoadable {searchPackages.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedGetSearchedPackagesUC: GetSearchedPackagesUCProtocol {
    public func execute(packageName: String, isCask: Bool, searchPackages: LoadableSubject<[String]>) -> Void {
        let cancelBag = CancelBag()
        searchPackages.wrappedValue.setIsLoading(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}
