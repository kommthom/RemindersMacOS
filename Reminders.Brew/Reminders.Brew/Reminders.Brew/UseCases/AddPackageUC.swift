//
//  AddPackageUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultAddPackageUC: AddPackageUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(packageName: String, success: ExecutableSubject<TypeOfResult>) {
        let cancelBag = CancelBag()
        success.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.addPackage(packageName: packageName)
            }
            .sinkToExecutable {success.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
}

public class MockedAddPackageUC: AddPackageUCProtocol {

    public func execute(packageName: String, success: ExecutableSubject<TypeOfResult>) {
    }
    
}
