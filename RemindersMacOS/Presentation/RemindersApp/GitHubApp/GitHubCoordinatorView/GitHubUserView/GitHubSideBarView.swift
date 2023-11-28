//
//  UsersList.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.09.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain

struct GitHubSideBarView: View {
    let store: StoreOf<GitHubUser>
    @StateObject private var viewModel: GitHubUserViewModel = DIContainer.shared.resolve()
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @EnvironmentObject private var selectedTab: ObservableString
    @EnvironmentObject private var searchGitHubUser: ObservableString
    @EnvironmentObject private var isGitHubAuthenticated: ObservableBool
    @EnvironmentObject var gitHubFilterCriteria: GitHubFilterCriteria
    
    init(store: StoreOf<GitHubUser>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            NavigationSplitView(columnVisibility: $columnVisibility) {
                //GeometryReader { geometry in
                VStack {
                    HStack {
                        Button {
                            selectedTab.value = "app"
                            viewStore.send(.myListsButtonTapped)
                        } label: {
                            Image(systemName: "arrow.backward")
                        }.buttonStyle(.plain)
                            .padding()
                        ZStack (alignment: .trailing){
                            TextField("githubsidebar.text.searchuser", text: $viewModel.searchText)
                                .font(.title)
                            if !viewModel.isUserHeader {
                                Button (
                                    action: {
                                        viewStore.send(.editGitHubFilterCriteriaButtonTapped(viewModel.gitHubFilterCriteria))
                                    }, label: {
                                        Image(systemName: "figure.run.circle")
                                            .tint(.gray)
                                    }
                                )
                            }
                        }
                        Button {
                            if isGitHubAuthenticated.value {
                                viewModel.logOut()
                                isGitHubAuthenticated.value = false
                            } else {
                                viewStore.send(.logInToGitHub)
                            }
                        } label: {
                            Text(isGitHubAuthenticated.value ? "githubsidebar.button.logout" : "githubsidebar.button.login")
                        }.buttonStyle(.bordered)
                            .padding(.trailing)
                        Text("\(gitHubFilterCriteria.language)/\(gitHubFilterCriteria.titleContains)")
                            .frame(width: 0, height: 0)
                        Text("\(searchGitHubUser.value)")
                            .frame(width: 0, height: 0)
                    }
                    if viewModel.isUserHeader {
                        switch viewModel.userRepositoriesLoadable {
                        case .notRequested:
                            Text("Start loading")//.onAppear(perform: { viewModel.load() })
                        case .isLoading(_, _):
                            ProgressView().padding()
                        case .loaded(_):
                            showLoadedUser()
                            showLoadedRepositories()
                        case .failed(let error):
                            ErrorView(error: error, retryAction: viewModel.load)
                        }
                    } else {
                        switch viewModel.activeRepositoriesLoadable {
                        case .notRequested:
                            Text("Start loading")//.onAppear(perform: { viewModel.load() })
                        case .isLoading(_, _):
                            ProgressView().padding()
                        case .loaded(_):
                            Text("\(viewModel.title)")
                                .font(.title)
                            showLoadedRepositories()
                        case .failed(let error):
                            ErrorView(error: error, retryAction: viewModel.load)
                        }
                    }
                }
                .padding(.bottom)
                .frame(minWidth: Geometries.main.sidebarWidth[AppSection.gitHub.rawValue], maxWidth: .infinity, minHeight: Geometries.main.content[AppSection.gitHub.rawValue].height, maxHeight: .infinity, alignment: .leading)
            } detail: {
                if let firstRepository = viewModel.repositories?.first {
                    let detailVM: RepositoryDetailsViewModel = DIContainer.shared.resolve(argument: LoginRepositoryName(ownedBy: firstRepository.owner.login, named: firstRepository.name))
                    RepositoryDetailsView(viewModel: detailVM)
                        .frame(minWidth: Geometries.main.detailWidth[AppSection.gitHub.rawValue], maxWidth: .infinity, minHeight: Geometries.main.content[AppSection.gitHub.rawValue].height, maxHeight: .infinity)
                }
            }
            .onAppear(perform: {
                viewModel.searchText = searchGitHubUser.value
                viewModel.gitHubFilterCriteria = gitHubFilterCriteria
                viewModel.isAuthenticated = isGitHubAuthenticated.value
            })
            .onChange(of: searchGitHubUser) { newValue, _ in
                // Just import it once
                if searchGitHubUser.value != "" {
                    viewModel.searchText = searchGitHubUser.value
                    Delay(1).performWork {
                        searchGitHubUser.value = ""
                    }
                }
            }
            .onChange(of: gitHubFilterCriteria) { newValue, _ in
                viewModel.gitHubFilterCriteria = gitHubFilterCriteria
            }
            .onChange(of: isGitHubAuthenticated) { newValue, _ in
                viewModel.isAuthenticated = isGitHubAuthenticated.value
            }
        }
    }
    
    func showLoadedUser() -> some View {
        return HStack(alignment: .center) {
            if viewModel.isUserHeader && viewModel.imageURL != nil {
                RemoteImage(imageURL: viewModel.imageURL!, width: 60.0, height: 60.0)
            }
            VStack {
                Text("\(viewModel.userName)")
                    .font(.title)
                Text("\(viewModel.userFullName)")
                    .font(.caption)
            }
        }
        .frame(minWidth: 300 , maxWidth: .infinity, maxHeight: 60, alignment: .leading)
    }
    
    func showLoadedRepositories() -> some View {
        return List {
            ForEach(viewModel.repositories ?? []) { repository in
                NavigationLink {
                    let detailVM: RepositoryDetailsViewModel = DIContainer.shared.resolve(argument: LoginRepositoryName(ownedBy: repository.owner.login, named: repository.name))
                    RepositoryDetailsView(viewModel: detailVM)
                } label: {
                    HStack(alignment: .center) {
                        RemoteImage(imageURL: URL(string: repository.owner.avatarURL)!, width: 40.0, height: 40.0)
                        Text("\(repository.owner.login)/\(repository.name)")
                            .font(.title)
                        Spacer()
                        Text("\(repository.starCount ?? 0)")
                        Image(systemName: "star")
                    }
                    .padding(.leading)
                }
            }
        }
    }
}
