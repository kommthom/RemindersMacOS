//
//  CreateMyListItemIfNew.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.09.23.
//

import Foundation
import Reminders_Domain

// MARK: - Implementation -

public class DefaultCreateMyListItemIfNewUC: CreateMyListItemIfNewUCProtocol {
    private var repository: MyListsDBRepositoryProtocol
    
    public init(repository: MyListsDBRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(with param: CreateMyListItemIfNewParams) -> Void {
        var myList: MyList = MyList(id: UUID(), name: param.myListName, color: .blue, items: [])
        repository.saveIfNew(myList: &myList)
        let myListItem: MyListItem = MyListItem(itemDescription: param.itemDescription, title: param.title, id: UUID(), dueDate: param.dueDate, isCompleted: false, myList: myList, homepage: param.homepage, comments: "")
        repository.saveIfNew(myListItem: myListItem)
    }
}

public class MockedCreateMyListItemIfNewUC: CreateMyListItemIfNewUCProtocol {
    public func execute(with param: CreateMyListItemIfNewParams) -> Void {
    }
    
    public init() {
        
    }
}
