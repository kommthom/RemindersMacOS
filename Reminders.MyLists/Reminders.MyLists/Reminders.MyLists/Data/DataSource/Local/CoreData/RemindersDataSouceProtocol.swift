//
//  RemindersDataSouceProtocol.swift
//  Reminders.Domain
//
//  Created by Thomas on 12.11.23.
//

import Foundation
import Combine
import CoreData
import Reminders_Domain

public protocol RemindersDataSourceProtocol {
    typealias DBOperation<Result> = (NSManagedObjectContext) throws -> Result
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error>
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>,
                     map: @escaping (T) throws -> V?) -> AnyPublisher<LazyList<V>, Error>
    func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error>
    func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error>
    func newMyListMO() -> MyListMO
    func newMyListItemMO() -> MyListItemMO
    func newSettingMO() -> SettingsMO
    func deleteObject(myMO: NSManagedObject)
    func saveData()
}
