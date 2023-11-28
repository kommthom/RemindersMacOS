//
//  DeleteMyListItemUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.09.23.
//

import Foundation
import Reminders_Domain

// MARK: - Implementation -

public class DefaultDeleteMyListItemUC: DeleteMyListItemUCProtocol {
    private let myListsRepository: MyListsDBRepositoryProtocol
    
    public init(myListsRepository: MyListsDBRepositoryProtocol) {
        self.myListsRepository = myListsRepository
    }
    
    public func execute(myListItem: MyListItem) -> Void {
        myListsRepository.delete(myListItem: myListItem)
    }
}

public class MockedDeleteMyListItemUC: DeleteMyListItemUCProtocol {
    public func execute(myListItem: MyListItem) -> Void {
    }
    
    public init() {
        
    }
}
