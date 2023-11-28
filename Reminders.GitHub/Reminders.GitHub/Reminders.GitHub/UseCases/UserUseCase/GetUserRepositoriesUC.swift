//
//  UserRepositoriesUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 18.09.23.
//

import Foundation
import Siesta
import Reminders_Domain
import Combine

// MARK: - Implementation -

public class DefaultGetUserRepositoriesUC: GetUserRepositoriesUCProtocol {
    
    private let usersRepository: GitHubAPIProtocol
    @Published var userRepositoriesResult: UserRepositories = .init()
    
    public init(usersRepository: GitHubAPIProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func execute(userName: UserName, userRepositories: LoadableSubject<UserRepositories>) {
        var getUserResourceHandler: SiestaResourceHandler<User, UserName>?
        
        let cancelBag = CancelBag()
        userRepositories.wrappedValue.setIsLoading(cancelBag: cancelBag)
        AppLogger.gitHub.log("User repositories for \(userName.userName) start loading")
        self.userRepositoriesResult = .init()
        getUserResourceHandler = SiestaResourceHandler<User, UserName>
            .init(getResource: usersRepository.user, params: userName, { user in
                guard let resource = getUserResourceHandler?.resource, let userUnwrapped = user else {
                    self.userRepositoriesResult.user = isNull(user, User.mockedData[0])
                    self.publishUserRepositories(userRepositories: userRepositories)
                    return
                }
                self.userRepositoriesResult.user = userUnwrapped
                self.publishUserRepositories(userRepositories: userRepositories)
                let resourceUrlString: ResourceUrlString = .init(resource: resource, urlString: userUnwrapped.repositoriesURL)
                let _ = SiestaResourceHandler<[Repository], ResourceUrlString>
                    .init(getResource: self.usersRepository.userRepositories, params: resourceUrlString, { repositories in
                        self.userRepositoriesResult.repositories = .loaded(isNull(repositories, []))
                        self.publishUserRepositories(userRepositories: userRepositories)
                    })
            })
    }
    
    private func publishUserRepositories(userRepositories: LoadableSubject<UserRepositories>) {
        let _ = CurrentValueSubject<UserRepositories, Error>(userRepositoriesResult)
            .sinkToLoadable( {
                userRepositories.wrappedValue = $0
                AppLogger.gitHub.log("User repositories Sink to Loadable: \($0.value?.user?.name ?? "DefaultUser") / \($0.value?.repositories.currentValue?.count ?? 0)")
            } )
    }
}

public class MockedGetUserRepositoriesUC: GetUserRepositoriesUCProtocol {
    public func execute(userName: UserName, userRepositories: LoadableSubject<UserRepositories>) {
    }
    
    public init() {
    }
}
