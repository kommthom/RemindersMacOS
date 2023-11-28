//
//  RepositoryDetails.swift
//  RemindersMacOS
//
//  Created by Thomas on 04.09.23.
//

import SwiftUI
import Foundation
import Reminders_Domain

struct RepositoryDetailsView: View {
    @StateObject var viewModel: RepositoryDetailsViewModel
    @EnvironmentObject private var searchGitHubUser: ObservableString
    
    var body: some View {
        switch viewModel.repositoryLoadable {
        case .notRequested:
            Text("Start loading").onAppear(perform: {
                viewModel.loadRepository()
            })
        case .isLoading(_, _):
            ProgressView().padding()
        case .loaded(_):
            VStack {
                HStack {
                    Image(systemName: viewModel.isStarred ? "star.fill" : "star")
                    Button {
                        viewModel.toggleStar()
                    } label: {
                        Text(viewModel.isStarred ? "githubrepos.button.unstar" : "githubrepos.button.star")
                    }
                    .disabled(!viewModel.starrButtonEnabled)
                    .buttonStyle(.plain)
                    .padding(.trailing)
                    Text("\(viewModel.starCount)")
                    Spacer()
                    if (viewModel.homepage) == "" {
                        Text("githubrepos.text.nohomepage")
                            .padding(.trailing)
                    } else {
                        Link(viewModel.homepage , destination: URL(string: viewModel.homepage)!)
                            .padding(.trailing)
                    }
                }
                .padding()
                VStack {
                    Text(viewModel.description)
                        .padding(.bottom)
                    HStack {
                        VStack {
                            Text("githubrepos.text.languages")
                            Text(viewModel.languages)
                        }
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack {
                        VStack {
                            Text("githubrepos.text.contributors")
                            List {
                                ForEach(viewModel.contributors, id: \.self) { contributor in
                                    Button(
                                        action: {
                                            searchGitHubUser.value = contributor
                                        },
                                        label: {
                                            Text(contributor).padding(.leading)
                                            Spacer()
                                            Image(systemName: "arrow.forward")
                                        }
                                    )
                                    .buttonStyle(.plain)
                                }
                            }
                            .listStyle(.plain)
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            viewModel.makeItem()
                        } label: {
                            Text("githubrepos.button.makeitem")
                        }
                        .padding()
                    }
                }
                .padding()
            }
        case .failed(let error):
            ErrorView(error: error, retryAction: viewModel.loadRepository)
        }
    }
}

/*#if DEBUG
struct RepositoryDetails_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Resolver.shared.buildMockContainer()
 var viewModel: RepositoryDetailsViewModel // = DIContainer.shared.resolve()
        RepositoryDetailsView(repository: Repository.mockedData[0])
    }
}
#endif*/
