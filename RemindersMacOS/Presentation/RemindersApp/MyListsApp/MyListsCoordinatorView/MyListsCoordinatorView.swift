//
//  ToDoCoordinater.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.10.23.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct MyListsCoordinatorView: View {
    let store: StoreOf<MyListsCoordinator>

    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .myLists:
                    CaseLet(
                        /MyListsScreen.State.myLists,
                         action: MyListsScreen.Action.myLists,
                         then: MyListsSideBarView.init
                    )
                case .addNewList:
                    CaseLet(
                        /MyListsScreen.State.addNewList,
                         action: MyListsScreen.Action.addNewList,
                         then: AddNewListView.init
                    )
                case .editList:
                    CaseLet(
                        /MyListsScreen.State.editList,
                         action: MyListsScreen.Action.editList,
                         then: EditListView.init
                    )
                case .editListItem:
                    CaseLet(
                        /MyListsScreen.State.editListItem,
                         action: MyListsScreen.Action.editListItem,
                         then: EditListItemView.init
                    )
                }
            }
        }
    }
}
