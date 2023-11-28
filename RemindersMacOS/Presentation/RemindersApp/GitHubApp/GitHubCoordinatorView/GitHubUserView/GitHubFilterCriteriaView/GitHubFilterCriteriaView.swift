//
//  GitHubFilterCriteriaView.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.09.23.
//

import SwiftUI
import Swinject
import ComposableArchitecture
import Reminders_Domain

struct GitHubFilterCriteriaView: View {
    let store: StoreOf<GitHubFilterCriteriaReducer>
    @Inject private var updateGitHubFilterCriteriaUseCase: UpdateGitHubFilterCriteriaUCProtocol
    @EnvironmentObject private var gitHubFilterCriteria: GitHubFilterCriteria
    
    var body: some View {
        WithViewStore(store, observe: \.gitHubFilterCriteria) { viewStore in
            VStack(alignment: .leading) {
                TextField("githubfilter.text.language", text: $gitHubFilterCriteria.language)
                    .textFieldStyle(.plain)
                    .padding(.bottom)
                TextField("githubfilter.text.textcontains", text: $gitHubFilterCriteria.titleContains)
                    .textFieldStyle(.plain)
                Spacer()
                HStack {
                    Spacer()
                    Button("nutton.cancel") {
                        gitHubFilterCriteria.language = viewStore.state.language
                        gitHubFilterCriteria.titleContains = viewStore.state.titleContains
                        viewStore.send(.goBackTapped)
                    }
                    Button("button.ok") {
                        updateGitHubFilterCriteriaUseCase
                            .execute(gitHubFilterCriteria: gitHubFilterCriteria)
                        viewStore.send(.goBackTapped)
                    }.buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .frame(minWidth: 200, minHeight: 200)
        }
    }
}
