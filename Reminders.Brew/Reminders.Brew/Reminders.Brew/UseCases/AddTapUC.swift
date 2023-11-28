//
//  AddTapUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultAddTapUC: AddTapUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(tapName: String, success: ExecutableSubject<TypeOfResult>) {
        let cancelBag = CancelBag()
        success.wrappedValue.setIsExecuting(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.addTap(tapName: tapName)
            }
            .sinkToExecutable {success.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
}

public class MockedAddTapUC: AddTapUCProtocol {

    public func execute(tapName: String, success: ExecutableSubject<TypeOfResult>) {
    }
    
}
