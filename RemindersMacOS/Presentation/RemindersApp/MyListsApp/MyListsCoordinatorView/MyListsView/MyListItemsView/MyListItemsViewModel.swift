//
//  MyListItemsViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.11.23.
//

import Combine
import SwiftUI
import Reminders_Domain

class MyListItemsViewModel: ObservableObject, MyListItemsViewModelProtocol {
    private var interactor: MyListItemsInteractorProtocol
    
    // MARK: - Observable Properties -
    @Published var myListItems: [MyListItem]
    let myList: MyList
    @Published var newItemDescription: String
    @Published var newTitle: String
    @Published var newDueDate: DueDate?
    @Published var newHomePage: String
    @Published var newComments: String
    
    init(interactor: MyListItemsInteractorProtocol, myList: MyList) {
        self.interactor = interactor
        self.myList = myList
        self.myListItems = myList.items
        self.newItemDescription = ""
        self.newTitle = ""
        self.newDueDate = DueDate.tomorrow
        self.newHomePage = ""
        self.newComments = ""
    }
    
    func delete(myListItem: MyListItem) {
        interactor
            .delete(myListItem: myListItem)
    }
    
    func save() {
        let newMyListItem = MyListItem(itemDescription: newItemDescription, title: newTitle, id: UUID(), dueDate: newDueDate?.value, isCompleted: false, myList: myList, homepage: newHomePage, comments: newComments)
        interactor
            .save(myListItem: newMyListItem)
    }
    
    func markAsCompleted(myListItem: MyListItem) {
        interactor
            .markAsCompleted(myListItem: myListItem)
    }
    
    func initMyListItem() {
        self.newItemDescription = ""
        self.newTitle = ""
        self.newDueDate = DueDate.tomorrow
        self.newHomePage = ""
        self.newComments = ""
    }
}
