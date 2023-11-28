//
//  UninstallPackageUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultUninstallPackageUC: UninstallPackageUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(packageName: String, shouldRemoveAllAssociatedFiles: Bool, success: ExecutableSubject<Bool>) {
        let cancelBag = CancelBag()
        success.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.uninstallPackage(packageName: packageName, shouldRemoveAllAssociatedFiles: shouldRemoveAllAssociatedFiles)
            }
            .sinkToExecutable {success.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedUninstallPackageUC: UninstallPackageUCProtocol {
    public func execute(packageName: String, shouldRemoveAllAssociatedFiles: Bool, success: ExecutableSubject<Bool>) {
    }
    
    public init() {
        
    }
}
