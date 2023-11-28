//
//  EditListItemViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.09.23.
//

import Foundation
import Reminders_Domain

class EditListItemViewModel: ObservableObject {
    
    @Inject private var updateMyListItemUseCase: UpdateMyListItemUCProtocol
    
    private var myListItem: MyListItem? = nil
    @Published var itemDescription: String = ""
    @Published var title: String = ""
    @Published var dueDate: Date? = nil
    @Published var homepage: String = ""
    @Published var comments: String = ""
    
    func loadViewModel(myListItem: MyListItem) {
        self.myListItem = myListItem
        self.itemDescription = myListItem.itemDescription
        self.title = myListItem.title ?? ""
        self.dueDate = myListItem.dueDate
        self.homepage = myListItem.homepage ?? ""
        self.comments = myListItem.comments ?? ""
    }
    
    func save() {
        myListItem?.itemDescription = itemDescription
        myListItem?.title = title
        myListItem?.dueDate = dueDate
        myListItem?.homepage = homepage
        myListItem?.comments = comments
        if let myListItemCp = myListItem {
            updateMyListItemUseCase.execute(myListItem: myListItemCp)
        }
    }

}
