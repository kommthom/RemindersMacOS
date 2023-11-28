//
//  UpdateOnePackageUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.11.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultUpdateOnePackageUC: UpdateOnePackageUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(packageName: String, isCask: Bool, success: ExecutableSubject<Bool>) {
        let cancelBag = CancelBag()
        success.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.updateOnePackage(packageName: packageName, isCask: isCask)
            }
            .sinkToExecutable { success.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedUpdateOnePackageUC: UpdateOnePackageUCProtocol {
    public func execute(packageName: String, isCask: Bool, success: ExecutableSubject<Bool>) {
    }
    
    public init() {
        
    }
}
