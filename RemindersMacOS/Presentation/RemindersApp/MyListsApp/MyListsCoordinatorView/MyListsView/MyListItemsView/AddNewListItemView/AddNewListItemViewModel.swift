//
//  AddNewListItemViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 26.08.23.
//

import Foundation
import Reminders_Domain

class AddNewListItemViewModel: ObservableObject {
    
    // State
    var myList: MyList? = nil
    
    @Published var title: String = ""
    @Published var dueDate: DueDate? = nil
    @Published var itemDescription: String = ""
    @Published var homepage: String = ""
    @Published var comments: String = ""
    
    private let updateMyListItemUseCase: UpdateMyListItemUCProtocol
    
    init(updateMyListItemUseCase: UpdateMyListItemUCProtocol) {
        self.updateMyListItemUseCase = updateMyListItemUseCase
    }
    
    func save() {
        let myDueDate = dueDate ?? .today
        let myListItem = MyListItem(itemDescription: itemDescription, title: title, id: UUID(), dueDate: myDueDate.value, isCompleted: false, myList: myList!, homepage: homepage, comments: comments)
        myList?.items.append(myListItem)
        updateMyListItemUseCase.execute(myListItem: myListItem)
    }
    
    func setMyList(myList: MyList) -> Bool {
        self.myList = myList
        return true
    }
}
