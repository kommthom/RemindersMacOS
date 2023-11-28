//
//  getBrewTapInfoUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 19.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetBrewTapInfoUC: GetBrewTapInfoUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(tapName: String, homeBrewTapInfo: LoadableSubject<BrewTapInfo>) {
        
        let cancelBag = CancelBag()
        homeBrewTapInfo.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.getTapInfo(tapName: tapName)
            }
            .sinkToLoadable { homeBrewTapInfo.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedGetBrewTapInfoUC: GetBrewTapInfoUCProtocol {
    public func execute(tapName: String, homeBrewTapInfo: LoadableSubject<BrewTapInfo>) {
    }
    
    public init() {
        
    }
}
