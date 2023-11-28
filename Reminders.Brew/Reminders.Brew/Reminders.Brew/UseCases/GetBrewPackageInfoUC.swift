//
//  GetBrewPackageInfoUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 19.10.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetBrewPackageInfoUC: GetBrewPackageInfoUCProtocol {
    private let homeBrewShellRepository: HomeBrewShellRepositoryProtocol
    
    public init(homeBrewShellRepository: HomeBrewShellRepositoryProtocol) {
        self.homeBrewShellRepository = homeBrewShellRepository
    }
    
    public func execute(packageName: String, isCask: Bool, homeBrewPackageInfo: LoadableSubject<BrewPackageInfo>) {
        
        let cancelBag = CancelBag()
        homeBrewPackageInfo.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [homeBrewShellRepository] in
                homeBrewShellRepository.getPackageInfo(packageName: packageName, isCask: isCask)
            }
            .sinkToLoadable { homeBrewPackageInfo.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedGetBrewPackageInfoUC: GetBrewPackageInfoUCProtocol {
    public func execute(packageName: String, isCask: Bool, homeBrewPackageInfo: LoadableSubject<BrewPackageInfo>) {
    }
    
    public init() {
        
    }
}
