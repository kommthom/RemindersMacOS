//
//  MyListsDBRepository.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.09.23.
//

import Foundation
import Combine

public protocol MyListsDBRepositoryProtocol {
    func hasLoadedMyLists() -> AnyPublisher<Bool, Error>
    func store(myLists: [MyList]) -> AnyPublisher<Void, Error>
    func myLists() -> AnyPublisher<LazyList<MyList>, Error>
    func delete(myList: MyList)
    func delete(myListItem: MyListItem)
    func updateAndSave(myList: MyList)
    func updateAndSave(myListItem: MyListItem)
    func saveIfNew(myList: inout MyList)
    func saveIfNew(myListItem: MyListItem)
}
