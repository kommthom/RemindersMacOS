//
//  AppCoordinatorView.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.10.23.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

// This coordinator shows one of two child coordinators, depending on if logged in. It
// animates a transition between the two child coordinators.
struct MyListsAppCoordinatorView: View {
      let store: StoreOf<MyListsApp>

      var body: some View {
            WithViewStore(store, observe: { $0.isLoggedIn }) { viewStore in
                  VStack {
                        if viewStore.state {
                            MyListsCoordinatorView(store: store.scope(state: \.myLists, action: MyListsApp.Action.myLists))
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        } else {
                            LogInRemindersCoordinatorView(store: store.scope(state: \.logInReminders, action: MyListsApp.Action.logInReminders))
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        }
                  }
                  .animation(.default, value: viewStore.state)
            }
      }
}

/*#Preview {
    AppCoordinatorView()
}*/
