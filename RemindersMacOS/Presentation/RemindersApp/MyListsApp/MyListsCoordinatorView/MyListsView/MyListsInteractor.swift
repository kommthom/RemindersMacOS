//
//  MyListsInteractor.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.11.23.
//

import Foundation
import Reminders_Domain

final class DefaultMyListsInteractor: MyListsInteractorProtocol {
    
    // MARK: Use Cases
    
    private let getMyListsUseCase: GetMyListsUCProtocol
    private let updateMyListUseCase: UpdateMyListUCProtocol
    private var deleteMyListUseCase: DeleteMyListUCProtocol

    
    init(getMyListsUseCase: GetMyListsUCProtocol, updateMyListUseCase: UpdateMyListUCProtocol, deleteMyListUseCase: DeleteMyListUCProtocol) {
        self.getMyListsUseCase = getMyListsUseCase
        self.updateMyListUseCase = updateMyListUseCase
        self.deleteMyListUseCase = deleteMyListUseCase
    }
    
    func load(myLists: LoadableSubject<LazyList<MyList>>) {
        getMyListsUseCase
            .execute(myLists: myLists)
    }
    
    func deleteMyList(myList: MyList) {
        deleteMyListUseCase.execute(myList: myList)
    }
}

final class MockedMyListsInteractor: MyListsInteractorProtocol {
    func load(myLists: Reminders_Domain.LoadableSubject<Reminders_Domain.LazyList<Reminders_Domain.MyList>>) {
        
    }
    
    func deleteMyList(myList: Reminders_Domain.MyList) {
        
    }
}
