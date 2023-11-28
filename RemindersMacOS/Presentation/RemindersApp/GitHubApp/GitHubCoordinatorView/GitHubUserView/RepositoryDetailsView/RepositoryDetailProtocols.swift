//
//  RepositoryDetailProtocols.swift
//  RemindersMacOS
//
//  Created by Thomas on 21.11.23.
//

import Foundation
import Reminders_Domain

protocol RepositoryDetailInteractorProtocol {
    func toggleStar(repositoryDetail: RepositoryDetail, onCompletion: @escaping () -> Void)
    func loadRepository(loginRepositoryName: LoginRepositoryName, repository: LoadableSubject<RepositoryDetail>) -> Void
    func makeItem(repositoryDetail: RepositoryDetail)
}

protocol RepositoryDetailViewModelProtocol {
    var repositoryDetail: RepositoryDetail? { get set }
    func toggleStar()
    func loadRepository()
    func makeItem()
}
