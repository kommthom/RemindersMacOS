//
//  MyListCellViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 28.09.23.
//

import SwiftUI
import Reminders_Domain

extension MyListCell {
    class ViewModel: ObservableObject {
        @Inject private var deleteMyListUseCase: DeleteMyListUCProtocol
        var myList: MyList
        @Published var name: String
        @Published var color: Color
        @Published var count: Int
      
        init(myList: MyList) {
            self.myList = myList
            self.name = myList.name
            self.color = Color(myList.color ?? .clear)
            self.count = myList.items.count
        }
        
        func delete() {
            deleteMyListUseCase.execute(myList: myList)
        }
    }
}
