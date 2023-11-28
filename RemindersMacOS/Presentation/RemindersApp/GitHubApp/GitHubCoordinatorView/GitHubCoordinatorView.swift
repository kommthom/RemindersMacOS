//
//  GitHubAppCoordinatorView.swift
//  RemindersMacOS
//
//  Created by Thomas on 03.10.23.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct GitHubCoordinatorView: View {
      let store: StoreOf<GitHubCoordinator>

      var body: some View {
            TCARouter(store) { screen in
                  SwitchStore(screen) { screen in
                        switch screen {
                        case .gitHub:
                            CaseLet(
                                /GitHubScreen.State.gitHub,
                                 action: GitHubScreen.Action.gitHub,
                                 then: GitHubSideBarView.init(store: )
                            )
                        case .editGitHubFilterCriteria:
                            CaseLet(
                                /GitHubScreen.State.editGitHubFilterCriteria,
                                 action: GitHubScreen.Action.editGitHubFilterCriteria,
                                 then: GitHubFilterCriteriaView.init(store: )
                            )
                        case .logInToGitHub:
                            CaseLet(
                                /GitHubScreen.State.logInToGitHub,
                                 action: GitHubScreen.Action.logInToGitHub,
                                 then: LogInGitHubView.init(store: )
                            )
                        }
                  }
            }
      }
}

/*#Preview {
    GitHubCoordinatorView()
}*/

