//
//  UninstallTapUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultUninstallTapUC: UninstallTapUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(tapName: String, success: ExecutableSubject<Bool>) {
        let cancelBag = CancelBag()
        success.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.uninstallTap(tapName: tapName)
            }
            .sinkToExecutable {success.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedUninstallTapUC: UninstallTapUCProtocol {
    public func execute(tapName: String, success: ExecutableSubject<Bool>) {
    }
    
    public init() {
        
    }
}
