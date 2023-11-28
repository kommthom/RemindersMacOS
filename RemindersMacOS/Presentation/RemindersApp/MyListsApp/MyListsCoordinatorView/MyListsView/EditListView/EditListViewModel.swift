//
//  EditListViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.09.23.
//

import SwiftUI
import Reminders_Domain

class EditListViewModel: ObservableObject {
    
    // MARK: - Dependencies -
    
    @Inject private var updateMyListUseCase: UpdateMyListUCProtocol
    
    // MARK: - Observable Properties -
    @Published var name: String = ""
    @Published var color: Color = .clear
    
    private var myList: MyList? = nil
    
    func loadViewModel(myList: MyList) {
        self.myList = myList
        self.name = myList.name
        self.color = Color(myList.color ?? .clear)
    }
    
    func save() {
        myList?.name = name
        myList?.color = NSColor(color)
        if let myListCp = myList {
            updateMyListUseCase.execute(myList: myListCp)
        }
    }
}
