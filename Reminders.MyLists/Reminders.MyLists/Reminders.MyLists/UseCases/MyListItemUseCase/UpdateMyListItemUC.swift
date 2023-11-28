//
//  UpdateMyListItemUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.09.23.
//

import Foundation
import Reminders_Domain

// MARK: - Implementation -

public class DefaultUpdateMyListItemUC: UpdateMyListItemUCProtocol {
    private var repository: MyListsDBRepositoryProtocol
    
    public init(repository: MyListsDBRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(myListItem: MyListItem) -> Void {
        return repository.updateAndSave(myListItem: myListItem)
    }
}

public class MockedUpdateMyListItemUC: UpdateMyListItemUCProtocol {
    public func execute(myListItem: MyListItem) -> Void {
    }
    
    public init() {
        
    }
}
