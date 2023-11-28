//
//  DataSourceAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.11.23.
//

import Swinject
import Reminders_MyLists
import Reminders_Domain

final class DataSourceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(CoreDataStack.self) { _ in
            return CoreDataStack()
        }.inObjectScope(.container)
        /* siesta.service does all:
        container.register(ImagesDataSource.self) { resolver in
            return DefaultImagesDataSource(requestManager: resolver.resolve(RequestManager.self)!)
        }.inObjectScope(.container)*/
        container.register(RemindersDataSourceProtocol.self) { resolver in
            guard let dataStack = resolver.resolve(CoreDataStack.self) else {
                fatalError("LocalDataSourceProtocol dependency could not be resolved")
            }
            return DefaultRemindersDataSource(dataStack: dataStack)
        }.inObjectScope(.container)
    }

}
