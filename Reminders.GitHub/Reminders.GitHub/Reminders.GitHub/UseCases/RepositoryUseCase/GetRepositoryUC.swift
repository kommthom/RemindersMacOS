//
//  RepositoryUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 18.09.23.
//

import Foundation
import Siesta
import Reminders_Domain
import Combine

// MARK: - Implementation -

public class DefaultGetRepositoryUC: GetRepositoryUCProtocol {
    private let usersRepository: GitHubAPIProtocol
    private var loginRepositoryName: LoginRepositoryName?
    @Published var repositoryResult: RepositoryDetail = .init()
    
    public init(usersRepository: GitHubAPIProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func execute(loginRepositoryName: LoginRepositoryName, repository: LoadableSubject<RepositoryDetail>) {
        var getRepositoryResourceHandler: SiestaResourceHandler<Repository, LoginRepositoryName>?
        
        let cancelBag = CancelBag()
        self.loginRepositoryName = loginRepositoryName
        repository.wrappedValue.setIsLoading(cancelBag: cancelBag)
        self.repositoryResult = .init()
        getRepositoryResourceHandler = SiestaResourceHandler<Repository, LoginRepositoryName>
            .init(getResource: usersRepository.repository, params: loginRepositoryName, { retrievedRepository in
                self.repositoryResult.repository = isNull(retrievedRepository, Repository.mockedData[0])
                self.publishRepositoryDetail(repository: repository)
                guard let resource = getRepositoryResourceHandler?.resource, let contributorsUrl = self.repositoryResult.repository?.contributorsURL else { return }
                let resourceUrlStringContributors: ResourceUrlString = .init(resource: resource, urlString: contributorsUrl)
                AppLogger.gitHub.log("ContributorsUrl \(contributorsUrl)")
                self.repositoryResult.contributors = .loading
                let _ = SiestaResourceHandler<[Contributor], ResourceUrlString>
                    .init(getResource: self.usersRepository.optionalRelative, params: resourceUrlStringContributors, { contributors in
                        if let contributorsResult = contributors {
                            self.repositoryResult.contributors = .loaded(contributorsResult.map( { $0.login } ))
                            self.publishRepositoryDetail(repository: repository)
                        } else {
                            self.repositoryResult.contributors = .loaded([])
                        }
                        AppLogger.gitHub.log("Contributors retrieved: \(self.repositoryResult.contributors.currentValue?.joined(separator: ", ") ?? "")")
                       
                } )
                guard let languagesUrl = self.repositoryResult.repository?.languagesURL else { return }
                let resourceUrlStringLanguages: ResourceUrlString = .init(resource: resource, urlString: languagesUrl)
                self.repositoryResult.languages = .loading
                let _ = SiestaResourceHandler<[String: Int], ResourceUrlString>
                    .init(getResource: self.usersRepository.optionalRelative, params: resourceUrlStringLanguages, { languages in
                            if let languagesResult = languages {
                                let languagesList: [String] = languagesResult.keys.map( { $0 } )
                                self.repositoryResult.languages = .loaded(languagesList)
                            } else {
                                self.repositoryResult.languages = .loaded([])
                            }
                            AppLogger.gitHub.log("Languages retrieved: \(self.repositoryResult.languages.currentValue?.joined(separator: ", ") ?? "")")
                            self.publishRepositoryDetail(repository: repository)
                        } )
                self.repositoryResult.isStarred = .loading
                let _ = SiestaResourceHandler<Bool, LoginRepositoryName>
                    .init(getResource: self.usersRepository.currentUserStarred, params: loginRepositoryName, { isStarred in
                        self.repositoryResult.isStarred = .loaded(isNull(isStarred, false))
                        self.publishRepositoryDetail(repository: repository)
                        AppLogger.gitHub.log("IsStarred retrieved: \(String(describing: self.repositoryResult.isStarred.currentValue))")
                    } )
            })
    }
    
    private func publishRepositoryDetail(repository: LoadableSubject<RepositoryDetail>) {
        let _ = CurrentValueSubject<RepositoryDetail, Error>(repositoryResult)
            .sinkToLoadable( { repository.wrappedValue = $0 } )
    }
}

public class MockedGetRepositoryUC: GetRepositoryUCProtocol {

    public func execute(loginRepositoryName: LoginRepositoryName, repository: LoadableSubject<RepositoryDetail>) {

    }
    
    public init() {
    }
}
