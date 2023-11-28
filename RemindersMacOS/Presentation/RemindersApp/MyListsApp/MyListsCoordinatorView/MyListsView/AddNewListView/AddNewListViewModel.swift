//
//  AddNewListViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 24.09.23.
//

import SwiftUI
import Reminders_Domain

class AddNewListViewModel: ObservableObject {
    
    // MARK: - Dependencies -
    
    private let createMyListUseCase: CreateMyListUCProtocol
    
    // MARK: - Observable Properties -
    @Published var name: String
    @Published var color: Color

    init(createMyListUseCase: CreateMyListUCProtocol) {
        self.createMyListUseCase = createMyListUseCase
        self.name = ""
        self.color = .blue
    }
    
    func save() {
        createMyListUseCase.execute(myList: .init(id: UUID(), name: name, color: NSColor(color), items: []))
    }
}
