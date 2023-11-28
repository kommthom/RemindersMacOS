//
//  ToDoScreen.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.10.23.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct MyListsScreen: Reducer {
    enum State: Equatable, Identifiable {
        case myLists(MyListsReducer.State)
        case addNewList(AddNewList.State)
        case editList(EditList.State)
        case editListItem(EditListItem.State)

        var id: UUID {
            switch self {
            case .myLists(let state):
                return state.id
            case .addNewList(let state):
                return state.id
            case .editList(let state):
                return state.id
            case .editListItem(let state):
                return state.id
            }
        }
    }

    enum Action {
        case myLists(MyListsReducer.Action)
        case addNewList(AddNewList.Action)
        case editList(EditList.Action)
        case editListItem(EditListItem.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: /State.myLists, action: /Action.myLists) {
            MyListsReducer()
        }
        Scope(state: /State.addNewList, action: /Action.addNewList) {
            AddNewList()
        }
        Scope(state: /State.editList, action: /Action.editList) {
            EditList()
        }
        Scope(state: /State.editListItem, action: /Action.editListItem) {
            EditListItem()
        }
    }
}
