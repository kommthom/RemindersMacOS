//
//  MyListsDataSource.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.09.23.
//

import Foundation
import CoreData
import Combine
import Reminders_Domain

public class DefaultRemindersDataSource: RemindersDataSourceProtocol {
    private let dataStack: CoreDataStack
    
    private var managedObjectContext: NSManagedObjectContext {
        dataStack.mainContext
    }
    
    private var container: NSPersistentContainer {
        dataStack.container
    }
    
    private var bgQueue: DispatchQueue {
        dataStack.bgQueue
    }
    
    public init(dataStack: CoreDataStack) {
        self.dataStack = dataStack
    }
    public func deleteObject(myMO: NSManagedObject) {
        managedObjectContext.delete(myMO)
        dataStack.saveContext()
    }
    
    public func newMyListMO() -> MyListMO {
        return MyListMO(context: managedObjectContext)
    }
    
    public func newMyListItemMO() -> MyListItemMO {
        return MyListItemMO(context: managedObjectContext)
    }
    
    public func newSettingMO() -> SettingsMO {
        return SettingsMO(context: managedObjectContext)
    }
    
    public func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error> {
        return dataStack.onStoreIsReady
            .flatMap { [weak container] in
                Future<Int, Error> { promise in
                    do {
                        let count = try container?.viewContext.count(for: fetchRequest) ?? 0
                        promise(.success(count))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>,
                     map: @escaping (T) throws -> V?) -> AnyPublisher<LazyList<V>, Error> {
        assert(Thread.isMainThread)
        let fetch = Future<LazyList<V>, Error> { [weak container] promise in
            guard let context = container?.viewContext else { return }
            context.performAndWait {
                do {
                    let managedObjects = try context.fetch(fetchRequest)
                    let results = LazyList<V>(count: managedObjects.count,
                                              useCache: true) { [weak context] in
                        let object = managedObjects[$0]
                        let mapped = try map(object)
                        if let mo = object as? NSManagedObject {
                            // Turning object into a fault
                            context?.refresh(mo, mergeChanges: false)
                        }
                        return mapped
                    }
                    promise(.success(results))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        return dataStack.onStoreIsReady
            .flatMap { fetch }
            .eraseToAnyPublisher()
    }
    
    public func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error> {
        let update = Future<Result, Error> { [weak bgQueue, weak container] promise in
            bgQueue?.async {
                guard let context = container?.newBackgroundContext() else { return }
                //context.configureAsUpdateContext()
                context.performAndWait {
                    do {
                        let result = try operation(context)
                        if context.hasChanges {
                            try context.save()
                        }
                        context.reset()
                        promise(.success(result))
                    } catch {
                        context.reset()
                        promise(.failure(error))
                    }
                }
            }
        }
        return dataStack.onStoreIsReady
            .flatMap { update }
        //          .subscribe(on: bgQueue) // Does not work as stated in the docs. Using `bgQueue.async`
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    public func saveData() {
        dataStack.saveContext()
    }
}

