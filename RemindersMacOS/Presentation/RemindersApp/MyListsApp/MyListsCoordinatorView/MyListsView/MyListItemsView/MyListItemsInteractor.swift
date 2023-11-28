//
//  MyListItemsInteractor.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.11.23.
//

import Foundation
import Reminders_Domain

final class DefaultMyListItemsInteractor: MyListItemsInteractorProtocol {
    
    // MARK: Use Cases
    
    private let deleteMyListItemUseCase: DeleteMyListItemUCProtocol
    private let updateMyListItemUseCase: UpdateMyListItemUCProtocol
    private let createMyListItemUseCase: CreateMyListItemUCProtocol
    
    init(deleteMyListItemUseCase: DeleteMyListItemUCProtocol, updateMyListItemUseCase: UpdateMyListItemUCProtocol, createMyListItemUseCase: CreateMyListItemUCProtocol) {
        self.deleteMyListItemUseCase = deleteMyListItemUseCase
        self.updateMyListItemUseCase = updateMyListItemUseCase
        self.createMyListItemUseCase = createMyListItemUseCase
    }
    
    func markAsCompleted(myListItem: MyListItem) {
        var myListItemCp = myListItem
        myListItemCp.isCompleted = true
        updateMyListItemUseCase.execute(myListItem: myListItemCp)
    }
    
    func delete(myListItem: MyListItem) {
        deleteMyListItemUseCase.execute(myListItem: myListItem)
    }
    
    func save(myListItem: MyListItem) {
        createMyListItemUseCase
            .execute(myListItem: myListItem)
    }
}

final class MockedMyListItemsInteractor: MyListItemsInteractorProtocol {
    func save(myListItem: Reminders_Domain.MyListItem) {
        
    }
    
    func markAsCompleted(myListItem: Reminders_Domain.MyListItem) {
        
    }
    
    func delete(myListItem: Reminders_Domain.MyListItem) {
        
    }
}
