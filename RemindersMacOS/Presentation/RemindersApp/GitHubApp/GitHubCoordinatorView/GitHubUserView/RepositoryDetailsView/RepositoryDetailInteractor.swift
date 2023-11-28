//
//  RepositoryDetailInteractor.swift
//  RemindersMacOS
//
//  Created by Thomas on 21.11.23.
//

import Foundation
import Reminders_Domain

final class DefaultRepositoryDetailInteractor: RepositoryDetailInteractorProtocol {
    
    // MARK: Use Cases
    
    private var setStarredUseCase: SetStarredUCProtocol
    private var getRepositoryUseCase: GetRepositoryUCProtocol
    private var createMyListItemIfNewUseCase: CreateMyListItemIfNewUCProtocol
    
    init(setStarredUseCase: SetStarredUCProtocol, getRepositoryUseCase: GetRepositoryUCProtocol, createMyListItemIfNewUseCase: CreateMyListItemIfNewUCProtocol) {
        self.setStarredUseCase = setStarredUseCase
        self.getRepositoryUseCase = getRepositoryUseCase
        self.createMyListItemIfNewUseCase = createMyListItemIfNewUseCase
    }
    
    func toggleStar(repositoryDetail: RepositoryDetail, onCompletion: @escaping () -> Void) {
        guard let _ = repositoryDetail.repository else { return }
        let loginRepositoryNameIsStarred = LoginRepositoryNameIsStarred(ownedBy: repositoryDetail.repository!.owner.login, named: repositoryDetail.repository!.name, isStarred: !(repositoryDetail.isStarred.currentValue ?? false))
       setStarredUseCase
            .execute(loginRepositoryNameIsStarred: loginRepositoryNameIsStarred, onCompletion: onCompletion)
        repositoryDetail.isStarred = .loaded(!(repositoryDetail.isStarred.currentValue ?? false))
    }
    
    func loadRepository(loginRepositoryName: LoginRepositoryName, repository: LoadableSubject<RepositoryDetail>) -> Void {
        getRepositoryUseCase
            .execute(loginRepositoryName: loginRepositoryName, repository: repository)
    }
    
    func makeItem(repositoryDetail: RepositoryDetail) {
        createMyListItemIfNewUseCase
            .execute(with:  CreateMyListItemIfNewParams(
                myListName: repositoryDetail.repository?.owner.login ?? "Nobody",
                itemDescription: repositoryDetail.repository?.description ?? "No description",
                title: repositoryDetail.repository?.name,
            dueDate: Calendar(identifier: .gregorian).date(byAdding: .day, value: 14, to: Date())!,
                homepage: repositoryDetail.repository?.homepage))
    }
}

final class MockedRepositoryDetailInteractor: RepositoryDetailInteractorProtocol {
    func toggleStar(repositoryDetail: RepositoryDetail, onCompletion: @escaping () -> Void) {
      
    }
    
    func loadRepository(loginRepositoryName: LoginRepositoryName, repository: LoadableSubject<RepositoryDetail>) {
       
    }
    
    func makeItem(repositoryDetail: RepositoryDetail) {
        
    }
    
}
