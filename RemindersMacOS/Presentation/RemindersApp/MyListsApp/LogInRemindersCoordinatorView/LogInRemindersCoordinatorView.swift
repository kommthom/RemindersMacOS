//
//  LogInRemindersCoordinatorView.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.10.23.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct LogInRemindersCoordinatorView: View {
  let store: StoreOf<LogInRemindersCoordinator>

  var body: some View {
      TCARouter(store) { screen in
          SwitchStore(screen) { screen in
              switch screen {
              case .welcome:
                  CaseLet(
                    /LogInRemindersScreen.State.welcome,
                     action: LogInRemindersScreen.Action.welcome,
                     then: WelcomeView.init
                  )

              case .logInReminders:
                  CaseLet(
                    /LogInRemindersScreen.State.logInReminders,
                     action: LogInRemindersScreen.Action.logInReminders,
                     then: LogInRemindersView.init
                  )
              }
          }
      }
    }
}
