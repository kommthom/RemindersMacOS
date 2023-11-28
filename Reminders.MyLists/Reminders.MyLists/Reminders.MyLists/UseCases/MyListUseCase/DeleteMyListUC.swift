//
//  DeleteMyListUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.09.23.
//

import Foundation
import Combine
import Reminders_Domain

// MARK: - Implementation -

public class DefaultDeleteMyListUC: DeleteMyListUCProtocol {
    private let myListsRepository: MyListsDBRepositoryProtocol
    
    public init(myListsRepository: MyListsDBRepositoryProtocol) {
        self.myListsRepository = myListsRepository
    }
    
    public func execute(myList: MyList) -> Void {
        myListsRepository.delete(myList: myList)
    }
}

public class MockedDeleteMyListUC: DeleteMyListUCProtocol {
    public func execute(myList: MyList) -> Void {
    }
    
    public init() {
        
    }
}
