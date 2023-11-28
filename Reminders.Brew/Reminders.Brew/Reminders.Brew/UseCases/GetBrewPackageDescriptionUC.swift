//
//  GetBrewPackageDescriptionUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 31.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetBrewPackageDescriptionUC: GetBrewPackageDescriptionUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(packageName: String, isCask: Bool, packageDescription: LoadableSubject<BrewPackageDescription>) -> Void {
        
        let cancelBag = CancelBag()
        packageDescription.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.brewPackageDescription(packageName: packageName, isCask: isCask)
            }
            .sinkToLoadable {packageDescription.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedGetBrewPackageDescriptionUC: GetBrewPackageDescriptionUCProtocol {
    public func execute(packageName: String, isCask: Bool, packageDescription: LoadableSubject<BrewPackageDescription>) -> Void {
        let cancelBag = CancelBag()
        packageDescription.wrappedValue.setIsLoading(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}
