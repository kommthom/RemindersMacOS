//
//  RepositoryDetailsViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 04.09.23.
//

import Foundation
import SwiftUI
import Reminders_Domain
  
class RepositoryDetailsViewModel: ObservableObject, RepositoryDetailViewModelProtocol {
    private var interactor: RepositoryDetailInteractorProtocol
    let loginRepositoryName: LoginRepositoryName
    var repositoryDetail: RepositoryDetail?

    @Published var repositoryLoadable: Loadable<RepositoryDetail> {
        didSet {
            switch repositoryLoadable {
            case .notRequested, .isLoading(_, _), .failed(_):
                dummy()
            case .loaded(let repositoryDetail):
                self.repositoryDetail = repositoryDetail
                showRepository()
                if repositoryDetail.languages.isLoaded {
                    languages = repositoryDetail.languages.currentValue?.joined(separator: " • ") ?? "-"
                }
                if repositoryDetail.contributors.isLoaded {
                    contributors = repositoryDetail.contributors.currentValue ?? .init()
                }
                if repositoryDetail.isStarred.isLoaded {
                    isStarred = repositoryDetail.isStarred.currentValue ?? false
                }
            }
        }
    }
    @Published var contributors: [String]
    @Published var languages: String
    @Published var isStarred: Bool
    @Published var homepage: String
    @Published var starrButtonEnabled: Bool
    @Published var description: String
    @Published var starCount: Int
    
    init(interactor: RepositoryDetailInteractorProtocol, loginRepositoryName: LoginRepositoryName) {
        self.interactor = interactor
        self.loginRepositoryName = loginRepositoryName
        self.repositoryLoadable = .notRequested
        self.starrButtonEnabled = false
        self.repositoryDetail = nil
        self.contributors = .init()
        self.description = "No description"
        self.starCount = 0
        self.homepage = "No homepage"
        self.languages = "-"
        self.isStarred = false
    }

    private func showRepository() {
        if let repository = repositoryDetail?.repository {
            description = repository.description ?? "No description".localized
            starCount = repository.starCount ?? 0
            homepage = ((repository.homepage ?? "") == "" ? "https://github.com/\(repository.owner.login)/\(repository.name )" : repository.homepage) ?? ""
            starrButtonEnabled = true
        } else {
            description = "No description".localized
            starCount = 0
            homepage = ""
            starrButtonEnabled = false
        }
        languages = "loading...".localized
        contributors = ["loading...".localized]
        isStarred = false
    }
    
    func toggleStar() {
        guard let repositoryDetail = repositoryDetail else { return }
        startStarRequestAnimation()
        interactor.toggleStar(repositoryDetail: repositoryDetail, onCompletion: { self.stopStarRequestAnimation() } )
        isStarred = repositoryDetail.isStarred.currentValue ?? false
    }
    
    @objc
    private func startStarRequestAnimation() {
        starrButtonEnabled = false
    }
    
    @objc
    private func stopStarRequestAnimation() {
        starrButtonEnabled = true
    }

    func loadRepository() {
        interactor.loadRepository(loginRepositoryName: loginRepositoryName, repository: loadableSubject(\.repositoryLoadable))
    }
    
    func makeItem() {
        guard let repositoryDetail = repositoryDetail else { return }
        interactor.makeItem(repositoryDetail: repositoryDetail)
    }
}
