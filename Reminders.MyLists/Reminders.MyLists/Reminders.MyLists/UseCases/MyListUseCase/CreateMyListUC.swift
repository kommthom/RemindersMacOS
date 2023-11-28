//
//  CreateMyListUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.09.23.
//

import Foundation
import Reminders_Domain

// MARK: - Implementation -

public class DefaultCreateMyListUC: CreateMyListUCProtocol {
    private var repository: MyListsDBRepositoryProtocol
    
    public init(repository: MyListsDBRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(myList: MyList) -> Void {
        return repository.updateAndSave(myList: myList)
    }
}

public class MockedCreateMyListUC: CreateMyListUCProtocol {
    public func execute(myList: MyList) -> Void {
    }
    
    public init() {
        
    }
}
