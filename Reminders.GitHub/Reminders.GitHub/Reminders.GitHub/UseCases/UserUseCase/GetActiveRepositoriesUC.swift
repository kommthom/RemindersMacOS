//
//  ActiveRepositoriesUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 18.09.23.
//

import Foundation
import Siesta
import Reminders_Domain
import Combine

// MARK: - Implementation -

public class DefaultGetActiveRepositoriesUC: GetActiveRepositoriesUCProtocol {
    
    private let usersRepository: GitHubAPIProtocol
    
    @Published var activeRepositoriesResult: ActiveRepositories = .init()
    
    public init(usersRepository: GitHubAPIProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func execute(filterCriteria: GitHubFilterCriteria, activeRepositories: LoadableSubject<ActiveRepositories>) {
        let cancelBag = CancelBag()
        self.activeRepositoriesResult = .init()
        activeRepositories.wrappedValue.setIsLoading(cancelBag: cancelBag)
        AppLogger.gitHub.log("Active repositories for \(filterCriteria.language)/\(filterCriteria.titleContains) start loading")
        self.activeRepositoriesResult.repositories = .loading
        let _ = SiestaResourceHandler<[Repository], GitHubFilterCriteria>.init(getResource: usersRepository.activeRepositories, params: filterCriteria, { repositories in
                self.activeRepositoriesResult.repositories = .loaded(isNull(repositories, []))
                self.publishActiveRepositories(activeRepositories: activeRepositories)
            } )
    }
    
    private func publishActiveRepositories(activeRepositories: LoadableSubject<ActiveRepositories>) {
        let _ = CurrentValueSubject<ActiveRepositories, Error>(activeRepositoriesResult)
            .sinkToLoadable( {
                activeRepositories.wrappedValue = $0
                AppLogger.gitHub.log("Active repositories Sink to Loadable: \($0.value?.repositories.currentValue?.count ?? 0)")
            } )
    }
}

public class MockedGetActiveRepositoriesUC: GetActiveRepositoriesUCProtocol {
    public func execute(filterCriteria: GitHubFilterCriteria, activeRepositories: LoadableSubject<ActiveRepositories>) {
    }
    
    public init() {
    }
}
