//
//  PinAndUnpinPackageUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 19.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultPinAndUnpinPackageUC: PinAndUnpinPackageUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(packageName: String, pinned: Bool, success: ExecutableSubject<Bool>) {
        let cancelBag = CancelBag()
        success.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.pinAndUnpinPackage(packageName: packageName, pinned: pinned)
            }
            .sinkToExecutable { success.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedPinAndUnpinPackageUC: PinAndUnpinPackageUCProtocol {
    public func execute(packageName: String, pinned: Bool, success: ExecutableSubject<Bool>) {
    }
    
    public init() {
        
    }
}
