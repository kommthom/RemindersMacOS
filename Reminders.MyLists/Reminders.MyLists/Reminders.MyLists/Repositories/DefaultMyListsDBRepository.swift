//
//  MyListsDBRepository.swift
//  RemindersMacOS
//
//  Created by Thomas on 19.08.23.
//

import Foundation
import Combine
import Reminders_Domain

public struct DefaultMyListsDBRepository: MyListsDBRepositoryProtocol {
    private let dataSource: RemindersDataSourceProtocol
    
    public init(dataSource: RemindersDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    public func updateAndSave(myList: MyList) {
        let predicate = NSPredicate(format: "id = %@", myList.id as CVarArg)
        let result = dataSource.fetchFirst(MyListMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let myListMO = managedObject {
                update(myListMO: myListMO, from: myList)
            } else {
                createMyListMO(from: myList)
            }
        case .failure(_):
            AppLogger.reminders.log("Couldn't fetch ProjectMO to save")
        }
    }
    
    private func update(myListMO: MyListMO, from myList: MyList) {
        myListMO.name = myList.name
        myListMO.color = myList.color
        let myListItemMOs = myList.items.compactMap({getMyListItemMO(from: $0)})
        myListMO.items = NSSet(array: myListItemMOs)
    }
    
    private func getMyListItemMO(from myListItem: MyListItem?) -> MyListItemMO? {
        guard let myListItem = myListItem else { return nil }
        let predicate = NSPredicate(format: "id = %@", myListItem.id as CVarArg)
        let result = dataSource.fetchFirst(MyListItemMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let myListItemMO = managedObject {
                return myListItemMO
            } else {
                return nil
            }
        case .failure(_):
            return nil
        }
    }
    private func getMyListMO(from myList: MyList?) -> MyListMO? {
        guard let myList = myList else { return nil }
        let predicate = NSPredicate(format: "id = %@", myList.id as CVarArg)
        let result = dataSource.fetchFirst(MyListMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let myListMO = managedObject {
                return myListMO
            } else {
                return nil
            }
        case .failure(_):
            return nil
        }
    }
    
    private func createMyListMO(from myList: MyList) {
        let myListMO = dataSource.newMyListMO()
        myListMO.id = myList.id
        update(myListMO: myListMO, from: myList)
    }
    
    public func updateAndSave(myListItem: MyListItem) {
        let predicate = NSPredicate(format: "id = %@", myListItem.id as CVarArg)
        let result = dataSource.fetchFirst(MyListItemMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let myListItemMO = managedObject {
                update(myListItemMO: myListItemMO, from: myListItem)
            } else {
                createMyListItemMO(from: myListItem)
            }
        case .failure(_):
            AppLogger.reminders.log("Couldn't fetch TodoMO to save")
        }
        
        dataSource.saveData()
    }
    
    private func update(myListItemMO: MyListItemMO, from myListItem: MyListItem) {
        myListItemMO.itemDescription = myListItem.itemDescription
        myListItemMO.title = myListItem.title
        myListItemMO.dueDate = myListItem.dueDate
        myListItemMO.isCompleted = myListItem.isCompleted
        myListItemMO.homepage = myListItem.homepage
        myListItemMO.comments = myListItem.comments
    }
    
    private func createMyListItemMO(from myListItem: MyListItem) {
        let myListItemMO = dataSource.newMyListItemMO()
        myListItemMO.id = myListItem.id
        update(myListItemMO: myListItemMO, from: myListItem)
        if let myList = getMyListMO(from: myListItem.myList) {
            myList.addToItems(myListItemMO)
        }
    }
    
    public func store(myLists: [MyList]) -> AnyPublisher<Void, Error> {
        return dataSource
            .update { context in
                myLists.forEach {
                    $0.store(in: context)
                }
            }
    }
    
    public func delete(myList: MyList) {
        let predicate = NSPredicate(format: "id = %@", myList.id as CVarArg)
        let result = dataSource.fetchFirst(MyListMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let myListMO = managedObject {
                dataSource.deleteObject(myMO: myListMO)
            }
        case .failure(_):
            AppLogger.reminders.log("Couldn't fetch MyListMO to save")
        }
    }
    
    public func delete(myListItem: MyListItem) {
        let predicate = NSPredicate(format: "id = %@", myListItem.id as CVarArg)
        let result = dataSource.fetchFirst(MyListItemMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let myListItemMO = managedObject {
                dataSource.deleteObject(myMO: myListItemMO)
            }
        case .failure(_):
            AppLogger.reminders.log("Couldn't fetch MyListItemMO to save")
        }
    }
    
    public func saveIfNew(myList: inout MyList) {
        let predicate = NSPredicate(format: "name = %@", myList.name as CVarArg)
        let result = dataSource.fetchFirst(MyListMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let myListMO = managedObject {
                myList.id = myListMO.id ?? UUID()
                myList.color = myListMO.color
                let itemsMO = myListMO.items?.allObjects.compactMap { $0 as? MyListItemMO }
                for item in itemsMO ?? [] {
                    myList.items.append(MyListItem(itemDescription: item.itemDescription, title: item.title, id: item.id, dueDate: item.dueDate, isCompleted: item.isCompleted, myList: myList, homepage: item.homepage, comments: item.comments))
                }
            } else {
                createMyListMO(from: myList)
                dataSource.saveData()
            }
        case .failure(_):
            AppLogger.reminders.log("Couldn't fetch TodoMO to save")
        }
        
    }
    
    public func saveIfNew(myListItem: MyListItem) {
        let searchedListItem = myListItem.myList?.items.first { $0.title == myListItem.title }
        if let searchedListItem = searchedListItem {
            AppLogger.reminders.log("Item '\(searchedListItem.title ?? "")' already exists")
        } else {
            createMyListItemMO(from: myListItem)
            dataSource.saveData()
        }
    }
    
    public func hasLoadedMyLists() -> AnyPublisher<Bool, Error> {
        let fetchRequest = MyListMO.fetchRequest()
        fetchRequest.fetchLimit = 1
        return dataSource
            .count(fetchRequest)
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }
    
    public func myLists() -> AnyPublisher<LazyList<MyList>, Error> {
        let fetchRequest = MyListMO.fetchRequest()
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.fetchBatchSize = 10
        return dataSource
            .fetch(fetchRequest) {
                MyList(managedObject: $0)
            }
    }
}

public struct MockedMyListsDBRepository: MyListsDBRepositoryProtocol {
    public func hasLoadedMyLists() -> AnyPublisher<Bool, Error> {
        return Just(false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func store(myLists: [MyList]) -> AnyPublisher<Void, Error> {
        return Empty()
            //.setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func myLists() -> AnyPublisher<LazyList<MyList>, Error> {
        let results = LazyList<MyList>(count: 1, useCache: true) { _ in
            return MyList.mockedData[0]
        }
        return Just(results)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func delete(myList: MyList) {
    }
    
    public func delete(myListItem: MyListItem) {
    }
    
    public func updateAndSave(myList: MyList) {
    }
    
    public func updateAndSave(myListItem: MyListItem) {
    }
    
    public func saveIfNew(myList: inout MyList) {
    }
    
    public func saveIfNew(myListItem: MyListItem) {
    }
    
}
