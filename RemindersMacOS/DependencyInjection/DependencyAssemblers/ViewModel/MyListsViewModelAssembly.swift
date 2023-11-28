//
//  MyListsViewModelAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Foundation
import Swinject
import Reminders_Domain
import Reminders_MyLists

final class MyListsViewModelAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LogInRemindersViewModel.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return LogInRemindersViewModel(
                logInUseCase: useCaseProvider.logInRemindersUC()
            )
        }
        container.register(MyListsViewModel.self) { resolver in
            guard let myListsInteractor = resolver.resolve(MyListsInteractorProtocol.self) else {
                fatalError("MyListsInteractorProtocol dependency could not be resolved")
            }
            return MyListsViewModel(
                interactor: myListsInteractor
            )
        }
        container.register(AddNewListViewModel.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return AddNewListViewModel(
                createMyListUseCase: useCaseProvider.createMyListUC()
            )
        }
        container.register(EditListViewModel.self) { resolver in
            EditListViewModel(
            )
        }
        container.register(EditListItemViewModel.self) { resolver in
            EditListItemViewModel(
            )
        }
        container.register(MyListItemsViewModel.self) { (resolver, myList) in
            guard let myListItemsInteractor = resolver.resolve(MyListItemsInteractorProtocol.self) else {
                fatalError("MyListItemsInteractorProtocol dependency could not be resolved")
            }
            return MyListItemsViewModel(
                interactor: myListItemsInteractor,
                myList: myList
            )
        }
        container.register(AddNewListItemViewModel.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return AddNewListItemViewModel(
                updateMyListItemUseCase: useCaseProvider.updateMyListItemUC()
            )
        }
    }
}
