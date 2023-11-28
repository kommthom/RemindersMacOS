//
//  CoreDataStack.swift
//  RemindersMacOS
//
//  Created by Thomas on 22.08.23.
//

import CoreData
import Combine
import Reminders_Domain
import Foundation

open class CoreDataStack {
    
    let container: NSPersistentContainer
    private let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
    let bgQueue = DispatchQueue(label: "coredata")
    
    public init(directory: FileManager.SearchPathDirectory = .documentDirectory,
         domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
         version vNumber: UInt = CoreDataStack.Version.actual) {
        let version = Version(vNumber)
        
        ValueTransformer.setValueTransformer(NSColorTransformer(), forName: NSValueTransformerName("NSColorTransformer"))
        AppLogger.reminders.log("directory: \(FileManager.SearchPathDirectory.documentDirectory) domainMask: \(FileManager.SearchPathDomainMask.userDomainMask) version: \(version.modelName)")
        
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: version.modelName, withExtension:"momd") else {
                fatalError("Error loading model from bundle")
        }
        AppLogger.reminders.log("modelURL: \(modelURL.absoluteString)")
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        container = NSPersistentContainer(name: version.modelName, managedObjectModel: mom)
        if let url = version.dbFileURL(directory, domainMask) {
            let store = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [store]
        }
        bgQueue.async { [weak isStoreLoaded, weak container] in
            container?.loadPersistentStores { (storeDescription, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        isStoreLoaded?.send(completion: .failure(error))
                    } else {
                        isStoreLoaded?.value = true
                    }
                }
            }
        }
    }
    
    public lazy var mainContext: NSManagedObjectContext = {
        return self.container.viewContext
    }()
    
    public func newDerivedContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        return context
    }
    
    public func saveContext() {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
                NotificationCenter.default.post(name: Constants.Notifications.contextChanged, object: "Save Context at \(Date())", userInfo: nil)
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    public func saveContext(_ context: NSManagedObjectContext) {
        if context != mainContext {
            saveDerivedContext(context)
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    public func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            self.saveContext(self.mainContext)
        }
    }
    
    public var onStoreIsReady: AnyPublisher<Void, Error> {
        return isStoreLoaded
            .filter { $0 }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
}

// MARK: - Versioning

extension CoreDataStack.Version {
    public static var actual: UInt { 1 }
    }

extension CoreDataStack {
    public struct Version {
        private let number: UInt
        
        public init(_ number: UInt) {
            self.number = number
        }
        
        public var modelName: String {
            return "RemindersModel"
        }
        
        public func dbFileURL(_ directory: FileManager.SearchPathDirectory,
                       _ domainMask: FileManager.SearchPathDomainMask) -> URL? {
            let dbFilename = FileManager.default
                .urls(for: directory, in: domainMask).first?
                .appendingPathComponent(subpathToDB)
            AppLogger.reminders.log("dbFileURL: \(dbFilename!.absoluteString)")
            return dbFilename
        }
        
        private var subpathToDB: String {
            return "db.sql"
        }
    }
}

