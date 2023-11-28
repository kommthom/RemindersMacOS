//
//  MyListItemsProtocols.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.11.23.
//

import Foundation
import Reminders_Domain

protocol MyListItemsInteractorProtocol {
    func markAsCompleted(myListItem: MyListItem)
    func delete(myListItem: MyListItem)
    func save(myListItem: MyListItem)
}

protocol MyListItemsViewModelProtocol {
    var myList: MyList { get }
    func initMyListItem() -> Void
    func markAsCompleted(myListItem: MyListItem)
    func delete(myListItem: MyListItem)
    func save()
}
