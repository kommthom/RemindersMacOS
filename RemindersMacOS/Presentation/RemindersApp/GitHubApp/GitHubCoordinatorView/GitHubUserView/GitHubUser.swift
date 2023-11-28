//
//  GitHubUser.swift
//  RemindersMacOS
//
//  Created by Thomas on 03.10.23.
//

import Foundation
import TCACoordinators
import ComposableArchitecture
import Reminders_Domain

struct GitHubUser: Reducer {
      struct State: Equatable {
          let id = UUID()

      }

      enum Action: Equatable {
          case myListsButtonTapped
          case editGitHubFilterCriteriaButtonTapped(GitHubFilterCriteria)
          case logInToGitHub
      }

      var body: some ReducerOf<Self> {
          Reduce { state, action in
              switch action {
              case .myListsButtonTapped, .editGitHubFilterCriteriaButtonTapped, .logInToGitHub:
                  return .none
              }
          }
      }
}
