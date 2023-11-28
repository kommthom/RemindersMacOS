//
//  MyListsProtocols.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.11.23.
//

import Foundation
import Reminders_Domain

protocol MyListsInteractorProtocol {
    func load(myLists: LoadableSubject<LazyList<MyList>>)
    func deleteMyList(myList: MyList)
}

protocol MyListsViewModelProtocol {
    var myLists: LazyList<MyList>? { get set }
    func load()
    func deleteMyList(myList: MyList)
}
