//
//  MyListsUCAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.11.23.
//

import Swinject
import Reminders_Domain
import Reminders_MyLists

final class MyListsUCAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LogInRemindersUCProtocol.self) { resolver in
            guard let repository = resolver.resolve(SettingsDBRepositoryProtocol.self) else {
                fatalError("LogInRemindersUCProtocol dependency could not be resolved")
            }
            return DefaultLogInRemindersUC(repository: repository)
        }.inObjectScope(.container)
        container.register(GetMyListsUCProtocol.self) { resolver in
            guard let myListsRepository = resolver.resolve(MyListsDBRepositoryProtocol.self) else {
                fatalError("GetMyListsUCProtocol dependency could not be resolved")
            }
            return DefaultGetMyListsUC(myListsRepository: myListsRepository)
        }.inObjectScope(.container)
        container.register(DeleteMyListUCProtocol.self) { resolver in
            guard let myListsRepository = resolver.resolve(MyListsDBRepositoryProtocol.self) else {
                fatalError("DeleteMyListUCProtocol dependency could not be resolved")
            }
            return DefaultDeleteMyListUC(myListsRepository: myListsRepository)
        }.inObjectScope(.container)
        container.register(DeleteMyListItemUCProtocol.self) { resolver in
            guard let myListsRepository = resolver.resolve(MyListsDBRepositoryProtocol.self) else {
                fatalError("DeleteMyListItemUCProtocol dependency could not be resolved")
            }
            return DefaultDeleteMyListItemUC(myListsRepository: myListsRepository)
        }.inObjectScope(.container)
        container.register(CreateMyListUCProtocol.self) { resolver in
            guard let myListsRepository = resolver.resolve(MyListsDBRepositoryProtocol.self) else {
                fatalError("CreateMyListUCProtocol dependency could not be resolved")
            }
            return DefaultCreateMyListUC(repository: myListsRepository)
        }.inObjectScope(.container)
        container.register(CreateMyListItemUCProtocol.self) { resolver in
            guard let myListsRepository = resolver.resolve(MyListsDBRepositoryProtocol.self) else {
                fatalError("CreateMyListItemUCProtocol dependency could not be resolved")
            }
            return DefaultCreateMyListItemUC(repository: myListsRepository)
        }.inObjectScope(.container)
        container.register(UpdateMyListUCProtocol.self) { resolver in
            guard let myListsRepository = resolver.resolve(MyListsDBRepositoryProtocol.self) else {
                fatalError("UpdateMyListUCProtocol dependency could not be resolved")
            }
            return DefaultUpdateMyListUC(repository: myListsRepository)
        }.inObjectScope(.container)
        container.register(UpdateMyListItemUCProtocol.self) { resolver in
            guard let myListsRepository = resolver.resolve(MyListsDBRepositoryProtocol.self) else {
                fatalError("UpdateMyListItemUCProtocol dependency could not be resolved")
            }
            return DefaultUpdateMyListItemUC(repository: myListsRepository)
        }.inObjectScope(.container)
        container.register(CreateMyListItemIfNewUCProtocol.self) { resolver in
            guard let myListsRepository = resolver.resolve(MyListsDBRepositoryProtocol.self) else {
                fatalError("CreateMyListItemIfNewUCProtocol dependency could not be resolved")
            }
            return DefaultCreateMyListItemIfNewUC(repository: myListsRepository)
        }.inObjectScope(.container)
    }
}

final class MockedMyListsUCAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LogInRemindersUCProtocol.self) { resolver in
            return MockedLogInRemindersUC()
        }.inObjectScope(.container)
        container.register(GetMyListsUCProtocol.self) { resolver in
            return MockedGetMyListsUC()
        }.inObjectScope(.container)
        container.register(DeleteMyListUCProtocol.self) { resolver in
            return MockedDeleteMyListUC()
        }.inObjectScope(.container)
        container.register(DeleteMyListItemUCProtocol.self) { resolver in
            return MockedDeleteMyListItemUC()
        }.inObjectScope(.container)
        container.register(CreateMyListUCProtocol.self) { resolver in
            return MockedCreateMyListUC()
        }.inObjectScope(.container)
        container.register(CreateMyListItemUCProtocol.self) { resolver in
            return MockedCreateMyListItemUC()
        }.inObjectScope(.container)
        container.register(UpdateMyListUCProtocol.self) { resolver in
            return MockedUpdateMyListUC()
        }.inObjectScope(.container)
        container.register(UpdateMyListItemUCProtocol.self) { resolver in
            return MockedUpdateMyListItemUC()
        }.inObjectScope(.container)
        container.register(CreateMyListItemIfNewUCProtocol.self) { resolver in
            return MockedCreateMyListItemIfNewUC()
        }.inObjectScope(.container)
    }
}
